class ChatResponsesController < ApplicationController
  include ActionController::Live

  def show
    response.headers['Content-Type']  = 'text/event-stream'
    response.headers['Last-Modified'] = Time.now.httpdate
    sse                               = SSE.new(response.stream, event: "message")
    client                            = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])

    document = Document.find(params[:document_id])
    context = document.content

    # Save user message
    user_message = document.chat_messages.create!(
      role: 'user',
      content: params[:prompt]
    )
    Rails.logger.info "Saved user message: #{user_message.id}"

    begin
      assistant_response = ""
      client.chat(
        parameters: {
          model:    "gpt-3.5-turbo",
          messages: [
            { 
              role: "system", 
              content: "You are a helpful assistant that answers questions about the provided PDF document. Use the following context to answer questions: #{context}" 
            },
            { role: "user", content: params[:prompt] }
          ],
          stream:   proc do |chunk|
            content = chunk.dig("choices", 0, "delta", "content")
            if content.nil?
              return
            end
            assistant_response += content
            Rails.logger.info "Streaming content: #{content}"
            sse.write({
                        message: content,
                      })
          end
        }
      )

      # Save assistant's complete response
      if assistant_response.present?
        Rails.logger.info "Saving assistant response: #{assistant_response.length} characters"
        assistant_message = document.chat_messages.create!(
          role: 'assistant',
          content: assistant_response
        )
        Rails.logger.info "Saved assistant message: #{assistant_message.id}"
      else
        Rails.logger.warn "No assistant response to save"
      end
    rescue => e
      Rails.logger.error "Chat response error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      sse.write({ message: "Error: #{e.message}" })
    ensure
      sse.close
    end
  end
end

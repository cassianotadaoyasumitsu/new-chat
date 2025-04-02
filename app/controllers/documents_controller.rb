class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def show
    @document = Document.find(params[:id])
    @chat_messages = @document.chat_messages.chronological
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params.except(:pdf_file))
    
    if params[:document][:pdf_file].present?
      pdf_file = params[:document][:pdf_file]
      reader = PDF::Reader.new(pdf_file.tempfile)
      @document.content = reader.pages.map(&:text).join("\n")
    end

    if @document.save
      @document.pdf_file.attach(params[:document][:pdf_file])
      redirect_to @document, notice: 'Document was successfully uploaded.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def document_params
    params.require(:document).permit(:title, :pdf_file)
  end
end

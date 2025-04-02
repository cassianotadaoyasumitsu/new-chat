# Mini ChatGPT

A Ruby on Rails application that implements a mini version of ChatGPT using the OpenAI API.

## Prerequisites

- Ruby 3.2.2
- Rails 7.0.8
- SQLite3
- OpenAI API access

## Setup Instructions

1. Clone the repository:
```bash
git clone <your-repository-url>
cd mini-chatgpt
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
```

4. Configure environment variables:
   - Copy the `.env.example` file to `.env`
   - Update the following variables in `.env`:
     - `OPENAI_ACCESS_TOKEN`: Your OpenAI API access token
     - `OPENAI_API_KEY`: Your OpenAI API key
     - `OPENAI_ORGANIZATION_ID`: Your OpenAI organization ID

5. Start the Rails server:
```bash
rails server
```

The application will be available at `http://localhost:3000`

## Features

- Integration with OpenAI's GPT models
- PDF processing capabilities
- Hotwire/Turbo for real-time updates
- Stimulus.js for JavaScript functionality

## Development

- The application uses SQLite3 as the database
- Hotwire/Turbo is used for real-time updates
- Stimulus.js is used for JavaScript functionality
- PDF processing is handled by the pdf-reader gem

## Testing

To run the test suite:
```bash
rails test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

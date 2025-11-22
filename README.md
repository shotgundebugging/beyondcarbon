# BeyondCarbon

A Rails 8 application for visualizing employment data affected by environmental and economic stressors across different regions and sectors.

## Overview

BeyondCarbon provides an interactive platform to explore how various stressors—including climate impacts (heat stress, sea level rise, air pollution) and economic changes (automation, policy transitions)—affect employment across different economic sectors in multiple countries.

The application allows users to:
- Compare employment impacts across 10 global regions
- Analyze 5 different types of stressors
- Visualize data across 10 economic sectors
- Toggle between absolute employment figures and percentage share metrics
- Sort and filter data dynamically with an interactive chart interface

## Features

- **Interactive Dashboard**: Real-time filtering and visualization using Turbo Frames
- **Multi-dimensional Analysis**: Explore data by region, stressor type, sector, and metric
- **Dynamic Charts**: Visualize employment data with customizable sorting and filtering
- **Responsive Design**: Clean, modern interface that works across devices
- **Sample Data**: Pre-populated demonstration dataset for immediate exploration

## Technology Stack

- **Framework**: Ruby on Rails 8.0.2
- **Ruby Version**: 3.4.5
- **Database**: SQLite3
- **Frontend**: 
  - Hotwire (Turbo & Stimulus)
  - Importmap for JavaScript
  - Propshaft for assets
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **WebSockets**: Solid Cable
- **Testing**: RSpec, Capybara, Selenium WebDriver
- **Code Quality**: RuboCop (Rails Omakase), Brakeman
- **Deployment**: Kamal, Docker, Thruster

## Prerequisites

- Ruby 3.4.5 or higher
- SQLite3
- Node.js (for JavaScript dependencies)
- Docker (optional, for containerized deployment)

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/shotgundebugging/beyondcarbon.git
   cd beyondcarbon
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup the database**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. **Seed the database with sample data**
   ```bash
   bin/rails db:seed
   ```
   This will create:
   - 10 regions (USA, GBR, FRA, DEU, BRA, ZAF, IND, CHN, AUS, CAN)
   - 10 sectors (Agriculture, Manufacturing, Services, Tourism, Energy, Construction, Transport, Healthcare, Education, Technology)
   - 5 stressors (Heat Stress, Sea Level Rise, Air Pollution, Automation, Policy Transition)
   - 500 employment data records

## Running the Application

### Development Server

Start the Rails server:
```bash
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000) in your browser.

### Development with Automatic Reloading

For development with automatic reloading:
```bash
bin/dev
```

## Testing

The project uses RSpec for testing.

### Run all tests
```bash
bundle exec rspec
```

### Run specific test files
```bash
bundle exec rspec spec/requests/employment_request_spec.rb
bundle exec rspec spec/services/employment_sample_spec.rb
```

### Code Quality Checks

**Run RuboCop for style checking:**
```bash
bundle exec rubocop
```

**Run Brakeman for security analysis:**
```bash
bundle exec brakeman
```

## Database Schema

### Regions
- `code`: Country code (e.g., USA, GBR)
- `name`: Full country name

### Employment Data
- `region_id`: Foreign key to regions
- `sector`: Economic sector name
- `stressor`: Type of environmental or economic stressor
- `value`: Employment figure (number of people)

## Project Structure

```
beyondcarbon/
├── app/
│   ├── controllers/
│   │   └── employment_controller.rb    # Main controller for data visualization
│   ├── models/
│   │   ├── region.rb                   # Region model (countries)
│   │   └── employment_data.rb          # Employment data model
│   └── views/
│       └── employment/
│           ├── index.html.erb          # Main dashboard
│           ├── _chart.html.erb         # Chart partial
│           └── _map.html.erb           # Map partial
├── db/
│   ├── migrate/                        # Database migrations
│   └── seeds.rb                        # Sample data seeder
├── spec/                               # RSpec tests
├── config/
│   ├── routes.rb                       # Application routes
│   └── deploy.yml                      # Kamal deployment configuration
└── Dockerfile                          # Container configuration
```

## Deployment

### Docker

Build the Docker image:
```bash
docker build -t beyondcarbon .
```

Run the container:
```bash
docker run -d -p 80:80 -e RAILS_MASTER_KEY=<your-master-key> --name beyondcarbon beyondcarbon
```

### Kamal

This application is configured for deployment with Kamal. Update `config/deploy.yml` with your server details, then:

```bash
kamal setup
kamal deploy
```

For more information, see the [Kamal documentation](https://kamal-deploy.org/).

## Configuration

### Environment Variables

- `RAILS_MASTER_KEY`: Required for production deployment (from `config/master.key`)
- `RAILS_ENV`: Environment setting (development, test, production)

### Database Configuration

Database settings are in `config/database.yml`. By default:
- **Development**: SQLite database at `storage/development.sqlite3`
- **Test**: SQLite database at `storage/test.sqlite3`
- **Production**: SQLite database at `storage/production.sqlite3`

## API Endpoints

- `GET /` - Main dashboard (employment index)
- `GET /employment/index` - Employment data visualization with filters
  - Query parameters:
    - `region`: Region code (e.g., USA, GBR)
    - `stressor`: Stressor type
    - `metric`: Display metric (people or share)
    - `topn`: Number of top sectors to display
    - `sort`: Sort order (desc, asc, or alpha)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow the Ruby style guide enforced by RuboCop
- Write tests for new features
- Run the test suite before submitting PRs
- Keep commits focused and atomic

## License

This project is available for use under the terms specified by the project owner.

## Support

For issues, questions, or contributions, please open an issue on the GitHub repository.

---

Built with Ruby on Rails 8 and modern web technologies.

# Spiro Horizon UI - Electric Vehicle Fleet Management Platform

![Spiro Logo](assets/images/africa_map.png)

## 🌟 Project Overview

**Spiro Horizon** is a comprehensive fleet management platform designed specifically for electric vehicle operations in Africa. This Flutter-based desktop application serves as the operational backbone for managing electric motorcycles, battery swapping stations, field agents, and the entire ecosystem of sustainable transportation infrastructure.

## 🎯 What This Project Achieves

### Core Mission
Spiro Horizon aims to revolutionize urban mobility in Africa by providing a complete management system for:
- **Electric motorcycle fleets** and their operations
- **Battery swapping stations** and infrastructure
- **Field agent management** and operations
- **Real-time analytics** and operational insights
- **Incident management** and support systems

### Business Impact
- **Sustainable Transportation**: Supporting the transition to electric vehicles in African cities
- **Operational Efficiency**: Streamlining fleet management and battery logistics
- **Data-Driven Decisions**: Providing analytics for optimizing operations
- **Scalable Infrastructure**: Managing growing networks of charging stations and agents

## 🏗️ Architecture Overview

### Technology Stack
- **Frontend**: Flutter (Multi-platform support: Windows, macOS, Linux)
- **State Management**: Stacked Architecture Pattern
- **Backend Communication**: RESTful APIs via Dio HTTP client
- **Charts & Analytics**: Syncfusion Charts, FL Chart
- **Maps Integration**: Flutter Map
- **Local Storage**: Flutter Secure Storage
- **Notifications**: Local Notifier

### Project Structure
```
lib/
├── Spiro/
│   ├── configs/          # Configuration and settings
│   ├── data/            # Data models and business logic
│   │   ├── internal/    # Internal data structures
│   │   └── external/    # External API models
│   ├── designs/         # Reusable UI components
│   ├── endpoints/       # API communication layer
│   ├── informatics/     # Analytics and data processing
│   ├── ui/             # User interface screens
│   │   ├── home/       # Main dashboard
│   │   ├── splash/     # Splash screen
│   │   └── parent/     # Base view models
│   └── utils/          # Utility functions and helpers
```

## 🚀 Key Features

### 1. **Comprehensive Dashboard**
- Real-time operational overview
- Multi-section navigation (Agents, Batteries, Stations, Reports)
- Quick action buttons for common tasks
- Responsive design for desktop platforms

### 2. **Agent Management System**
- Agent registration and profile management
- Contact information and station assignments
- Performance tracking and reporting
- Field operations coordination

### 3. **Battery Management**
- Battery registration with OEM details and serial numbers
- Battery type categorization and tracking
- Real-time status monitoring
- Maintenance and lifecycle management

### 4. **Station Operations**
- Charging station management and monitoring
- Location tracking with map integration
- Station capacity and utilization analytics
- Maintenance scheduling and alerts

### 5. **Analytics & Reporting**
- Interactive charts and visualizations
- Operational KPIs and metrics
- Custom report generation
- Data export capabilities

### 6. **Incident Management**
- Incident reporting and tracking
- Resolution workflow management
- Communication with field teams
- Documentation and follow-up

### 7. **Data Entry & Forms**
- Streamlined data input processes
- Form validation and error handling
- Bulk operations support
- Import/export functionality

## 🔧 Technical Features

### Cross-Platform Desktop Support
- **Windows**: Native desktop application
- **macOS**: Native desktop application  
- **Linux**: Native desktop application
- Window management with bitsdojo_window

### API Integration
- RESTful API communication with backend services
- Endpoint: `http://localhost:8080/spiro/horizon/`
- JSON data serialization and deserialization
- Error handling and retry mechanisms

### Data Models
- **UserRegistration**: Agent/user profile management
- **BatteryRequest**: Battery registration and tracking
- **BatteryHistoryRequest**: Battery usage and maintenance history
- Comprehensive JSON mapping for API communication

### Security & Storage
- Secure local storage for sensitive data
- Environment variable configuration (.env)
- Encrypted communication with backend services

## 🌍 Regional Focus: Africa

### Localization Features
- Africa map integration for geographic operations
- Region-specific operational requirements
- Multi-language support capability
- Local regulatory compliance considerations

### Infrastructure Adaptation
- Designed for varying internet connectivity
- Offline capability considerations
- Mobile-first operational workflows
- Local data caching and synchronization

## 📱 User Experience

### Target Users
1. **Fleet Managers**: Oversee overall operations and strategy
2. **Station Operators**: Manage charging stations and battery inventory
3. **Field Agents**: Handle on-ground operations and customer service
4. **Administrators**: System configuration and user management
5. **Analysts**: Data analysis and reporting

### Workflow Examples
1. **Agent Onboarding**: Registration → Profile Setup → Station Assignment → Training Tracking
2. **Battery Lifecycle**: Registration → Deployment → Usage Tracking → Maintenance → Retirement
3. **Incident Response**: Report → Assignment → Investigation → Resolution → Documentation

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ)
- Git for version control

### Installation
```bash
# Clone the repository
git clone https://github.com/AfricanVision/horizonui.git

# Navigate to project directory
cd horizonui/frontend

# Install dependencies
flutter pub get

# Create environment file
cp .env.example .env

# Run the application
flutter run
```

### Environment Configuration
Create a `.env` file in the root directory:
```env
API_BASE_URL=http://localhost:8080
API_TIMEOUT=30000
DEBUG_MODE=true
```

## 📊 Current Development Status

### Implemented Features ✅
- Main dashboard with sidebar navigation
- Agent management (CRUD operations)
- Battery management system
- Station management interface
- Basic analytics and reporting
- Form validation and data entry
- API communication layer

### In Progress 🚧
- Advanced analytics dashboards
- Real-time data synchronization
- Mobile companion app integration
- Enhanced reporting capabilities

### Planned Features 📋
- Multi-tenant support
- Advanced role-based permissions
- Integration with IoT devices
- Predictive maintenance algorithms
- Mobile app for field agents

## 🤝 Contributing

### Development Workflow
1. Create feature branch from `develop`
2. Implement changes with tests
3. Submit pull request for review
4. Merge after approval and testing

### Code Standards
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Document complex business logic
- Write unit tests for critical functions

## 📞 Support & Contact

For technical support, feature requests, or business inquiries:
- **Repository**: https://github.com/AfricanVision/horizonui
- **Organization**: AfricanVision
- **Project Lead**: spiro-shawn-matunda

## 📄 License

This project is proprietary software developed for Spiro's electric vehicle operations in Africa.

---

*Building the future of sustainable transportation in Africa, one electric vehicle at a time.* 🌍⚡🏍️

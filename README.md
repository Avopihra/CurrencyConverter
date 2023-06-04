# Currency Converter

The Currency Converter is an iOS application that allows users to convert currencies using the Currate service. It implements the VIPER architecture and includes features such as a local cache using CoreData, customizable currency pairs, and error handling. The application supports devices starting from iOS 11 and iPhone 5s.

## Requirements

The Currency Converter application has the following requirements:

- iOS 11 or later
- iPhone 5s or newer

## Features

- Currency conversion using the Currate service
- Local cache using CoreData for improved performance and reduced API requests

## Architecture

The Currency Converter application follows the VIPER architecture, which stands for View, Interactor, Presenter, Entity, and Router. This architecture provides a clear separation of concerns and improves the maintainability of the codebase.

- **View**: Responsible for presenting data to the user and capturing user interactions. It contains the user interface components.

- **Interactor**: Contains the business logic of the application. It interacts with the data sources, such as the Currate service and the local cache.

- **Presenter**: Formats the data received from the Interactor and provides it to the View for display. It also handles user interactions and communicates with other components.

- **Entity**: Represents the data models used in the application, such as currency rates and conversion information.

- **Router**: Handles navigation between different screens of the application.

## Contributions

Contributions to the Currency Converter project are welcome. If you encounter any issues or have suggestions for improvements, please open a new issue or submit a pull request on the GitHub repository.

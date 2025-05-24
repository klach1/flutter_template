# Copilot Instructions for Flutter Project

## Project Overview
This is a Flutter application following the MVVM architecture pattern with a clean separation of concerns. The code should follow the established patterns and folder structure.

## Architectural Patterns
- **Architecture**: MVVM (Model-View-ViewModel) with Repository pattern
- **State Management**: Provider with ChangeNotifier
- **Navigation**: go_router
- **API Client**: Dio for HTTP requests
- **Dependency Injection**: Provider with context.read()

## Code Generation Guidelines

### General
1. Follow the existing folder structure
2. Use consistent naming conventions
3. Keep UI logic separate from business logic
4. Implement proper error handling at all layers
5. Leverage existing utility classes (Result, Command)

### Creating a New Feature
When creating a new feature:

1. **Models**:
   - Create API models in `/lib/data/model/[feature]/`
   - Create domain models in `/lib/domain/models/[feature]/`
   
2. **Services**:
   - Create a service class in `/lib/data/services/api/[feature]_service.dart`
   - Inject the ApiClient dependency
   - Handle API requests and responses

3. **Repository**:
   - Create a repository in `/lib/data/repositories/[feature]_repository.dart`
   - Inject the service dependency
   - Convert API models to domain models

4. **ViewModel**:
   - Create a ViewModel in `/lib/ui/[feature]/viewmodels/[feature]_viewmodel.dart`
   - Extend ChangeNotifier
   - Inject the repository dependency
   - Handle UI state and business logic
   - Use notifyListeners() to update the UI

5. **UI**:
   - Create UI widgets in `/lib/ui/[feature]/widgets/`
   - Use Provider.of or Consumer for accessing ViewModels
   - Handle loading, error, and success states

6. **Routing**:
   - Add routes in `/lib/routing/routes.dart`
   - Configure route handlers in `/lib/routing/router.dart`

7. **Dependencies**:
   - Register dependencies in `/lib/config/dependencies.dart`

### Code Patterns

#### ViewModel Example
```dart
class FeatureViewModel extends ChangeNotifier {
  final FeatureRepository _repository;
  
  // State variables
  bool _isLoading = false;
  String? _error;
  List<ItemModel> _items = [];
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ItemModel> get items => _items;
  
  FeatureViewModel({required FeatureRepository repository}) 
      : _repository = repository;
  
  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _items = await _repository.getItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

#### Repository Example
```dart
class FeatureRepository {
  final FeatureService _service;
  
  FeatureRepository({required FeatureService service}) 
      : _service = service;
  
  Future<List<ItemModel>> getItems() async {
    try {
      final response = await _service.getItems();
      return response.map((data) => ItemModel.fromApiModel(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }
}
```

#### Service Example
```dart
class FeatureService {
  final ApiClient _client;
  
  FeatureService({required ApiClient apiClient}) : _client = apiClient;
  
  Future<List<ItemApiModel>> getItems() async {
    try {
      final response = await _client.get('/endpoint');
      return (response.data as List)
          .map((json) => ItemApiModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
```

#### UI Example
```dart
class FeaturePage extends StatelessWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature')),
      body: Consumer<FeatureViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }
          
          final items = viewModel.items;
          
          if (items.isEmpty) {
            return const Center(child: Text('No items found'));
          }
          
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => ItemTile(item: items[index]),
          );
        },
      ),
    );
  }
}
```

#### Dependency Registration Example
```dart
// In dependencies.dart
List<SingleChildWidget> get providers {
  return [
    // Add your new feature services, repositories, and viewmodels here
    Provider(create: (context) => FeatureService(apiClient: context.read())),
    Provider(create: (context) => FeatureRepository(service: context.read())),
    ChangeNotifierProvider(create: (context) => FeatureViewModel(repository: context.read())),
  ];
}
```

#### Router Configuration Example
```dart
// In router.dart
GoRouter router() {
  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      // Add your new feature routes here
      GoRoute(
        path: Routes.feature,
        builder: (context, state) => const FeaturePage(),
      ),
    ],
  );
}

// In routes.dart
abstract class Routes {
  static const feature = '/feature';
}
```

### Utility Classes

#### Using Result
```dart
// Using Result utility for error handling
final result = await repository.getData();
if (result.isSuccess) {
  // Handle success case
  final data = result.data!;
} else {
  // Handle error case
  final error = result.error!;
}
```

#### Using Command
```dart
// Using Command utility for async operations
final command = Command(() async {
  // Async operation
  await loadData();
});
await command.execute();
```

## Style Guidelines
1. Use `final` for variables that don't change
2. Use named parameters for better readability
3. Format code with `flutter format`
4. Follow the project's analysis options
5. Include proper documentation for public APIs
6. Use relative imports for project files
7. Group imports by type (dart, flutter, packages, project)
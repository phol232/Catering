# Implementation Plan - CaterPro Mobile App

- [x] 1. Set up project structure and dependencies
  - Update pubspec.yaml with required packages (flutter_bloc, supabase_flutter, get_it, go_router, flutter_dotenv, equatable, dartz, shared_preferences, cached_network_image)
  - Create core folder structure (config, theme, di, navigation, utils)
  - Create features folder structure (auth, events, quotes, menus)
  - Configure flutter_dotenv to load assets/env/.env file
  - Add assets path to pubspec.yaml
  - _Requirements: 16.1, 16.5_

- [x] 2. Implement core configuration and theme
  - [x] 2.1 Create environment configuration loader
    - Implement EnvConfig class to load Supabase credentials from .env
    - Add validation for required environment variables
    - _Requirements: 16.1_
  
  - [x] 2.2 Create Supabase configuration and initialization
    - Implement SupabaseConfig class with initialize method
    - Configure Supabase client with URL and anon key from env
    - Set up auth callback URL for OAuth
    - _Requirements: 16.2, 16.3_
  
  - [x] 2.3 Implement app theme with brand colors
    - Create AppColors class with YellowPastel, Black, GrayDark, GrayLight, WhiteAlmost constants
    - Implement CateringAppTheme with dark and light color schemes
    - Configure MaterialTheme with brand palette
    - _Requirements: 15.1, 15.2, 15.3, 15.4, 15.5_
  
  - [x] 2.4 Create validation utilities
    - Implement email validation function
    - Implement password validation (minimum 8 characters)
    - Create input sanitization utilities
    - _Requirements: 3.2_

- [x] 3. Implement authentication feature
  - [x] 3.1 Create auth data layer
    - Implement UserModel with fromJson, toJson, and toEntity methods
    - Create AuthRemoteDataSource interface and implementation
    - Implement Supabase auth methods (signInWithPassword, signUp, signInWithOAuth, signOut, currentSession)
    - Handle auth exceptions and map to failures
    - _Requirements: 3.2, 3.3, 4.2, 16.2_
  
  - [x] 3.2 Create auth domain layer
    - Define UserEntity
    - Create AuthRepository interface
    - Implement use cases: LoginWithEmail, RegisterWithEmail, LoginWithGoogle, Logout, GetCurrentUser
    - Define Failure types (AuthFailure, NetworkFailure, ValidationFailure)
    - _Requirements: 3.2, 3.3, 4.2_
  
  - [x] 3.3 Implement AuthRepositoryImpl
    - Implement all AuthRepository interface methods
    - Handle Supabase responses and errors
    - Map data models to domain entities
    - Store user profile in users table after registration
    - _Requirements: 3.2, 3.4, 4.2, 16.3_
  
  - [ ]* 3.4 Write property test for duplicate email rejection
    - **Property 8: Duplicate email rejection**
    - **Validates: Requirements 3.5**
  
  - [ ]* 3.5 Write property test for user profile persistence
    - **Property 7: User profile persistence completeness**
    - **Validates: Requirements 3.4**
  
  - [ ]* 3.6 Write property test for registration role assignment
    - **Property 6: Registration creates correct user role**
    - **Validates: Requirements 3.2**
  
  - [x] 3.7 Create auth presentation layer
    - Define AuthEvent classes (LoginWithEmailRequested, RegisterWithEmailRequested, LoginWithGoogleRequested, LogoutRequested, CheckStatusRequested)
    - Define AuthState classes (AuthInitial, AuthLoading, AuthAuthenticated, AuthUnauthenticated, AuthError)
    - Implement AuthBloc with event handlers
    - _Requirements: 3.2, 3.3, 4.2_
  
  - [ ]* 3.8 Write property test for valid credentials authentication
    - **Property 9: Valid credentials authentication**
    - **Validates: Requirements 4.2**
  
  - [ ]* 3.9 Write property test for invalid credentials error
    - **Property 11: Invalid credentials generic error**
    - **Validates: Requirements 4.4**
  
  - [x] 3.10 Create login screen UI
    - Build LoginScreen with email and password input fields
    - Add Google sign-in button with brand styling
    - Implement BlocListener for auth state changes
    - Show loading indicator during authentication
    - Display error messages for auth failures
    - Add navigation to register screen
    - _Requirements: 4.1, 4.4_
  
  - [x] 3.11 Create register screen UI
    - Build RegisterScreen with nombre, email, and password fields
    - Add Google sign-in button
    - Implement form validation
    - Show loading indicator during registration
    - Display error messages for registration failures
    - Add navigation to login screen
    - _Requirements: 3.1, 3.5_
  
  - [x] 3.12 Create reusable auth widgets
    - Implement EmailInputField widget with validation
    - Implement PasswordInputField widget with visibility toggle
    - Create SocialAuthButton widget for Google sign-in
    - Style widgets with brand colors
    - _Requirements: 15.1, 15.4_

- [x] 4. Implement session persistence and role-based navigation
  - [x] 4.1 Implement session persistence
    - Configure Supabase to persist sessions locally
    - Implement session restoration on app launch
    - Handle session expiration and refresh
    - _Requirements: 4.5, 16.4_
  
  - [ ]* 4.2 Write property test for session persistence
    - **Property 12: Session persistence across restarts**
    - **Validates: Requirements 4.5**
  
  - [ ]* 4.3 Write property test for session token inclusion
    - **Property 40: Session persistence mechanism**
    - **Validates: Requirements 16.4**
  
  - [x] 4.4 Implement role-based navigation
    - Create AppRouter with go_router
    - Define routes for all screens
    - Implement redirect logic based on auth state
    - Add role-based dashboard routing (CLIENTE, ADMIN, LOGISTICA, COCINA, GESTOR)
    - Preserve redirect URL for post-auth navigation
    - _Requirements: 4.3, 2.2, 2.3_
  
  - [ ]* 4.5 Write property test for role-based navigation
    - **Property 10: Role-based navigation**
    - **Validates: Requirements 4.3**

- [ ] 5. Checkpoint - Ensure authentication tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 6. Implement events feature (public browsing)
  - [ ] 6.1 Create event data layer
    - Implement EventModel with fromJson and toEntity methods
    - Create EventRemoteDataSource interface and implementation
    - Implement Supabase queries for public events (get_all_events function)
    - Implement search functionality with filters
    - Handle pagination with limit and offset
    - _Requirements: 1.1, 1.3, 1.4_
  
  - [ ] 6.2 Create event domain layer
    - Define EventEntity and EventDetailEntity
    - Create EventRepository interface
    - Implement use cases: GetPublicEvents, SearchEvents, GetEventDetail
    - _Requirements: 1.1, 1.3_
  
  - [ ] 6.3 Implement EventRepositoryImpl
    - Implement all EventRepository interface methods
    - Handle Supabase responses and pagination
    - Map data models to domain entities
    - _Requirements: 1.1, 1.3, 1.4_
  
  - [ ]* 6.4 Write property test for event display completeness
    - **Property 1: Event display completeness**
    - **Validates: Requirements 1.2**
  
  - [ ]* 6.5 Write property test for search result relevance
    - **Property 2: Search result relevance**
    - **Validates: Requirements 1.3**
  
  - [ ]* 6.6 Write property test for pagination consistency
    - **Property 3: Pagination consistency**
    - **Validates: Requirements 1.4**
  
  - [ ] 6.7 Create event presentation layer
    - Define EventListEvent and EventListState classes
    - Implement EventListBloc with pagination support
    - Define EventDetailEvent and EventDetailState classes
    - Implement EventDetailBloc
    - _Requirements: 1.1, 1.3_
  
  - [ ] 6.8 Create home screen UI
    - Build HomeScreen with app bar and search bar
    - Implement EventCarousel widget for featured events
    - Create event gallery with grid/list view
    - Add infinite scroll pagination
    - Implement pull-to-refresh
    - Style with brand colors (black background, gray cards)
    - _Requirements: 1.1, 1.4, 15.2, 15.3_
  
  - [ ] 6.9 Create event widgets
    - Implement EventCard widget with image, name, date, city, guest count
    - Create EventSearchBar widget with filter chips
    - Build EventCarousel with PageView
    - Add EventStatusBadge with color-coded statuses
    - _Requirements: 1.2, 15.1, 15.5_
  
  - [ ] 6.10 Create event detail screen
    - Build EventDetailScreen with full event information
    - Display menu preview and guest count
    - Show event images in gallery
    - Add "Request Quote" button (triggers auth check)
    - Allow access without authentication
    - _Requirements: 1.5, 2.1_

- [ ] 7. Implement quote request with auth gate
  - [ ] 7.1 Implement auth gate logic
    - Create auth check before quote request
    - Show login/register bottom sheet when unauthenticated user requests quote
    - Preserve quote context (event, menu, guests) during auth flow
    - Restore context after successful authentication
    - _Requirements: 2.1, 2.2, 2.3_
  
  - [ ]* 7.2 Write property test for quote context preservation
    - **Property 4: Quote context preservation**
    - **Validates: Requirements 2.2**
  
  - [ ]* 7.3 Write property test for navigation state preservation
    - **Property 5: Navigation state preservation on auth cancel**
    - **Validates: Requirements 2.4**

- [ ] 8. Implement client dashboard and event management
  - [ ] 8.1 Create client events data layer
    - Implement queries to fetch events by cliente_id
    - Add filtering by event status
    - _Requirements: 5.1, 5.3_
  
  - [ ] 8.2 Create client events domain layer
    - Implement GetClientEvents use case
    - Add FilterEventsByStatus use case
    - _Requirements: 5.1, 5.3_
  
  - [ ] 8.3 Create client events presentation layer
    - Define ClientEventsEvent and ClientEventsState classes
    - Implement ClientEventsBloc with filtering support
    - _Requirements: 5.1, 5.3_
  
  - [ ]* 8.4 Write property test for client event filtering
    - **Property 13: Client event filtering**
    - **Validates: Requirements 5.1**
  
  - [ ]* 8.5 Write property test for event status filtering
    - **Property 15: Event status filtering**
    - **Validates: Requirements 5.3**
  
  - [ ]* 8.6 Write property test for event card display
    - **Property 14: Event card display completeness**
    - **Validates: Requirements 5.2**
  
  - [ ] 8.7 Create client dashboard screen
    - Build ClientDashboardScreen with user greeting
    - Display client's events in list/grid view
    - Add status filter chips
    - Show event cards with all required information
    - Add "Request New Quote" button
    - _Requirements: 5.1, 5.2, 5.3_

- [ ] 9. Checkpoint - Ensure event browsing tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 10. Implement menus feature
  - [ ] 10.1 Create menu data layer
    - Implement MenuModel and DishModel with fromJson and toEntity
    - Create MenuRemoteDataSource interface and implementation
    - Implement queries for active menus and menu details
    - Implement dietary restriction filtering
    - _Requirements: 9.1, 9.2, 9.4_
  
  - [ ] 10.2 Create menu domain layer
    - Define MenuEntity, MenuDetailEntity, and DishEntity
    - Create MenuRepository interface
    - Implement use cases: GetActiveMenus, GetMenuDetail, FilterMenusByDietaryRestriction
    - _Requirements: 9.1, 9.2, 9.4_
  
  - [ ] 10.3 Implement MenuRepositoryImpl
    - Implement all MenuRepository interface methods
    - Handle menu_dishes relationship queries
    - Map data models to domain entities
    - _Requirements: 9.1, 9.2_
  
  - [ ]* 10.4 Write property test for menu display completeness
    - **Property 31: Menu display completeness**
    - **Validates: Requirements 9.1**
  
  - [ ]* 10.5 Write property test for menu dishes retrieval
    - **Property 32: Menu dishes retrieval**
    - **Validates: Requirements 9.2**
  
  - [ ]* 10.6 Write property test for dish display completeness
    - **Property 33: Dish display completeness**
    - **Validates: Requirements 9.3**
  
  - [ ]* 10.7 Write property test for dietary restriction filtering
    - **Property 34: Dietary restriction filtering**
    - **Validates: Requirements 9.4**
  
  - [ ]* 10.8 Write property test for dishes grouped by category
    - **Property 35: Dishes grouped by category**
    - **Validates: Requirements 9.5**
  
  - [ ] 10.9 Create menu presentation layer
    - Define MenuEvent and MenuState classes
    - Implement MenuBloc
    - _Requirements: 9.1_
  
  - [ ] 10.10 Create menu widgets
    - Implement MenuCard widget
    - Create DishListItem widget with dietary icons
    - Build DietaryFilterChips widget
    - _Requirements: 9.3, 9.4_
  
  - [ ] 10.11 Create menu detail screen
    - Build MenuDetailScreen with menu information
    - Display dishes grouped by category
    - Show dietary flags with icons
    - Add dietary filter functionality
    - _Requirements: 9.1, 9.2, 9.3, 9.5_

- [ ] 11. Implement quote calculation feature
  - [ ] 11.1 Create quote data layer
    - Implement QuoteModel and ExtraServiceItem with fromJson and toEntity
    - Create QuoteRemoteDataSource interface and implementation
    - Implement calculate_quote RPC call
    - Implement create quote request with event and extras
    - _Requirements: 6.1, 6.2_
  
  - [ ] 11.2 Create quote domain layer
    - Define QuoteEntity and ExtraServiceEntity
    - Create QuoteRepository interface
    - Implement use cases: CalculateQuote, CreateQuoteRequest
    - _Requirements: 6.1, 6.2_
  
  - [ ] 11.3 Implement QuoteRepositoryImpl
    - Implement all QuoteRepository interface methods
    - Call calculate_quote database function
    - Handle event creation and extras insertion
    - Update event_finance table
    - _Requirements: 6.2, 6.5_
  
  - [ ]* 11.4 Write property test for base cost calculation
    - **Property 16: Base cost calculation**
    - **Validates: Requirements 6.1**
  
  - [ ]* 11.5 Write property test for quote breakdown
    - **Property 18: Quote breakdown completeness**
    - **Validates: Requirements 6.3**
  
  - [ ]* 11.6 Write property test for quote recalculation
    - **Property 19: Quote recalculation on input change**
    - **Validates: Requirements 6.4**
  
  - [ ]* 11.7 Write property test for quote persistence
    - **Property 20: Quote persists to finance table**
    - **Validates: Requirements 6.5**
  
  - [ ] 11.8 Create quote presentation layer
    - Define QuoteEvent and QuoteState classes
    - Implement QuoteBloc with reactive recalculation
    - _Requirements: 6.1, 6.4_
  
  - [ ] 11.9 Create quote request screen
    - Build QuoteRequestScreen with form
    - Add MenuSelector widget
    - Create GuestCountInput widget
    - Implement ExtraServicesSelector widget
    - Show real-time quote calculation
    - Display itemized breakdown
    - Add "Confirm Quote" button
    - _Requirements: 6.1, 6.3, 6.4_
  
  - [ ] 11.10 Create quote widgets
    - Implement QuoteSummary widget with breakdown
    - Create ExtraServiceCard widget
    - Build quote calculation display with brand colors
    - _Requirements: 6.3, 15.1_

- [ ] 12. Implement extra services feature
  - [ ] 12.1 Create extra services data layer
    - Implement ExtraServiceModel with fromJson and toEntity
    - Add queries for active extra services
    - Implement event_extras CRUD operations
    - _Requirements: 7.1, 7.3, 7.4_
  
  - [ ] 12.2 Implement extra services in quote flow
    - Add extra services selection to quote request
    - Calculate subtotals for each service
    - Update quote when extras are added/removed
    - _Requirements: 7.2, 7.3, 7.4, 7.5_
  
  - [ ]* 12.3 Write property test for active services filtering
    - **Property 21: Active services filtering**
    - **Validates: Requirements 7.1**
  
  - [ ]* 12.4 Write property test for quantity input matching unit
    - **Property 22: Quantity input matches service unit**
    - **Validates: Requirements 7.2**
  
  - [ ]* 12.5 Write property test for extra service subtotal
    - **Property 23: Extra service subtotal calculation**
    - **Validates: Requirements 7.3**
  
  - [ ]* 12.6 Write property test for extra service removal
    - **Property 24: Extra service removal updates quote**
    - **Validates: Requirements 7.4**
  
  - [ ]* 12.7 Write property test for extra modification updates
    - **Property 25: Extra modification updates display**
    - **Validates: Requirements 7.5**

- [ ] 13. Checkpoint - Ensure quote calculation tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 14. Implement payment and reservation feature
  - [ ] 14.1 Create payment data layer
    - Implement PaymentModel with fromJson and toEntity
    - Add payment record creation
    - Implement payment status updates
    - Add event status transitions
    - _Requirements: 8.1, 8.2, 8.3, 8.4_
  
  - [ ] 14.2 Create payment domain layer
    - Define PaymentEntity
    - Create PaymentRepository interface
    - Implement use cases: InitiateDeposit, ConfirmPayment, UpdateEventStatus
    - _Requirements: 8.1, 8.2, 8.3_
  
  - [ ] 14.3 Implement PaymentRepositoryImpl
    - Implement all PaymentRepository interface methods
    - Handle event status transitions
    - Store payment details
    - _Requirements: 8.1, 8.2, 8.3, 8.4_
  
  - [ ]* 14.4 Write property test for quote confirmation state transition
    - **Property 26: Quote confirmation state transition**
    - **Validates: Requirements 8.1**
  
  - [ ]* 14.5 Write property test for deposit payment record creation
    - **Property 27: Deposit payment record creation**
    - **Validates: Requirements 8.2**
  
  - [ ]* 14.6 Write property test for payment confirmation state updates
    - **Property 28: Payment confirmation state updates**
    - **Validates: Requirements 8.3**
  
  - [ ]* 14.7 Write property test for payment data persistence
    - **Property 29: Payment data persistence**
    - **Validates: Requirements 8.4**
  
  - [ ]* 14.8 Write property test for reservation prevents double booking
    - **Property 30: Reservation prevents double booking**
    - **Validates: Requirements 8.5**
  
  - [ ] 14.9 Create payment presentation layer
    - Define PaymentEvent and PaymentState classes
    - Implement PaymentBloc
    - _Requirements: 8.1, 8.2, 8.3_
  
  - [ ] 14.10 Create payment screen (basic)
    - Build PaymentScreen with payment details
    - Show deposit amount and total
    - Add payment method selection
    - Implement payment confirmation
    - Update event status after payment
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

- [ ] 15. Implement dependency injection and app initialization
  - [ ] 15.1 Set up GetIt service locator
    - Register Supabase client
    - Register all data sources
    - Register all repositories
    - Register all use cases
    - Register all BLoCs as factories
    - _Requirements: 14.5_
  
  - [ ] 15.2 Create main.dart with app initialization
    - Load environment variables
    - Initialize Supabase
    - Set up dependency injection
    - Initialize app theme
    - Configure router
    - Wrap app with BlocProviders
    - _Requirements: 16.1, 16.2, 15.1_

- [ ] 16. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 17. Polish UI and add finishing touches
  - [ ] 17.1 Add loading states and error handling UI
    - Implement loading indicators with brand colors
    - Create error display widgets
    - Add retry mechanisms
    - _Requirements: 15.1_
  
  - [ ] 17.2 Add image caching and placeholders
    - Integrate cached_network_image
    - Create placeholder widgets
    - Add error image widgets
    - _Requirements: 1.2_
  
  - [ ] 17.3 Implement responsive design
    - Test on different screen sizes
    - Adjust layouts for tablets
    - Ensure touch targets are adequate
    - _Requirements: 15.1_
  
  - [ ] 17.4 Add animations and transitions
    - Implement page transitions
    - Add loading animations
    - Create smooth scroll effects
    - _Requirements: 1.4_

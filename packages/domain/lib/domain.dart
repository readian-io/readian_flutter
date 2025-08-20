library;

// Export domain entities, repositories, and use cases
// Note: Add specific exports as you create domain objects

export 'config/app_config.dart';
export 'utils/validation_utils.dart';

// Auth entities
export 'entities/auth_result.dart';
export 'entities/auth_token.dart';
export 'entities/user_entity.dart';
export 'entities/authentication_state.dart';

// Result types
export 'entities/result/login_result.dart';
export 'entities/result/registration_result.dart';
export 'entities/result/refresh_token_result.dart';
export 'entities/result/anon_reg_result.dart';


// Auth repository interface
export 'repositories/auth_repository.dart';

// Auth store
export 'store/authentication_store.dart';

// Errors
export 'errors/auth_domain_error.dart';

// Auth use cases 
export 'usecases/auth/login_usecase.dart';
export 'usecases/auth/register_usecase.dart';

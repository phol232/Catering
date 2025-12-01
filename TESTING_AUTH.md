# Pruebas de Autenticación - CaterPro

## ✅ Funcionalidades Implementadas

### 1. Registro de Usuario (Sign Up)
- ✅ Registro con email y contraseña
- ✅ Validación de email
- ✅ Validación de contraseña (mínimo 8 caracteres)
- ✅ Validación de nombre completo
- ✅ Creación automática de perfil en tabla `users`
- ✅ Rol por defecto: CLIENTE
- ✅ Detección de emails duplicados

### 2. Inicio de Sesión (Login)
- ✅ Login con email y contraseña
- ✅ Validación de credenciales
- ✅ Recuperación de perfil de usuario
- ✅ Navegación automática al dashboard según rol

### 3. Persistencia de Sesión
- ✅ Sesión guardada localmente
- ✅ Restauración automática al abrir la app
- ✅ Token de autenticación incluido en todas las peticiones

### 4. Navegación Basada en Roles
- ✅ CLIENTE → Panel de Cliente
- ✅ ADMIN → Panel de Administración
- ✅ LOGISTICA → Panel de Logística
- ✅ COCINA → Panel de Cocina
- ✅ GESTOR → Panel de Gestión

## 🧪 Cómo Probar

### Paso 1: Ejecutar la Aplicación
```bash
flutter run
```

### Paso 2: Probar Registro
1. En la pantalla de inicio, haz clic en "Iniciar Sesión"
2. Haz clic en "Regístrate"
3. Completa el formulario:
   - **Nombre Completo**: Tu nombre
   - **Email**: tu@email.com
   - **Contraseña**: mínimo 8 caracteres
4. Haz clic en "Registrarse"
5. Deberías ser redirigido al Panel de Cliente

### Paso 3: Probar Login
1. Cierra la app y vuelve a abrirla
2. Deberías ser redirigido automáticamente al dashboard (sesión persistente)
3. Si no, haz clic en "Iniciar Sesión"
4. Ingresa tus credenciales
5. Haz clic en "Iniciar Sesión"
6. Deberías ser redirigido al Panel de Cliente

### Paso 4: Probar Validaciones
1. Intenta registrarte con un email inválido → Error
2. Intenta registrarte con contraseña corta (< 8 caracteres) → Error
3. Intenta registrarte con un email ya existente → Error
4. Intenta hacer login con credenciales incorrectas → Error

## 📝 Mensajes de Error en Español

- ❌ "Por favor ingresa tu correo electrónico"
- ❌ "Por favor ingresa un correo electrónico válido"
- ❌ "Por favor ingresa tu contraseña"
- ❌ "La contraseña debe tener al menos 8 caracteres"
- ❌ "Por favor ingresa tu nombre"
- ❌ "Correo electrónico o contraseña incorrectos"
- ❌ "Este correo electrónico ya está registrado"

## 🔧 Configuración de Supabase

Las credenciales están en `assets/env/.env`:
```
API_URL_SUPABASE=https://awrqpnbvitqeymtxjimx.supabase.com
API_KEY_SUPABASE=sb_secret_vtNlSacmCMs1poNVCmd2Eg_6fwJ9ckW
```

## 📊 Estructura de la Tabla Users

```sql
CREATE TABLE users (
  id             BIGSERIAL PRIMARY KEY,
  nombre         VARCHAR(120) NOT NULL,
  email          VARCHAR(255) UNIQUE NOT NULL,
  telefono       VARCHAR(30),
  password_hash  TEXT NOT NULL,
  role           user_role NOT NULL DEFAULT 'CLIENTE',
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## 🐛 Solución de Problemas

### Error: "Failed to sign in"
- Verifica que las credenciales de Supabase sean correctas
- Verifica que la tabla `users` exista en Supabase
- Verifica que el email y contraseña sean correctos

### Error: "User already registered"
- El email ya está registrado en Supabase Auth
- Usa otro email o haz login con el existente

### La app no navega después del login
- Verifica que el usuario tenga un rol asignado en la tabla `users`
- Verifica que el router esté correctamente configurado

## ✨ Próximos Pasos

- [ ] Implementar recuperación de contraseña
- [ ] Implementar login con Google OAuth
- [ ] Agregar foto de perfil
- [ ] Implementar edición de perfil

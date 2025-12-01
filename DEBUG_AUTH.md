# 🐛 Debug de Autenticación

## Pasos para Debuggear

### 1. Ejecuta la app con logs
```bash
flutter run
```

### 2. Intenta registrarte
Cuando hagas clic en "Registrarse", deberías ver en la consola algo como:

```
🟢 AuthBloc: Register requested for tu@email.com
🔵 Starting sign up for: tu@email.com
🔵 Auth response: [user-id]
🔵 Creating user profile in database...
🔵 User profile created: [profile-id]
🟢 AuthBloc: Register success - tu@email.com
```

### 3. Si ves un error
Los logs te dirán exactamente dónde está fallando:

#### Error en Auth (Supabase Auth)
```
❌ Auth error: [mensaje de error]
```
**Posibles causas:**
- Email ya registrado
- Contraseña muy corta (< 6 caracteres en Supabase)
- Credenciales de Supabase incorrectas

#### Error en Database (Tabla users)
```
❌ Database error: [mensaje de error]
```
**Posibles causas:**
- La tabla `users` no existe
- Faltan permisos RLS (Row Level Security)
- El campo `password_hash` no acepta strings vacíos

#### Error inesperado
```
❌ Unexpected error: [mensaje de error]
```

## 🔧 Soluciones Comunes

### Problema 1: "No pasa nada" al registrarse

**Causa:** El error está siendo silenciado

**Solución:** Mira los logs en la consola. Deberías ver mensajes con 🔵, 🟢 o ❌

### Problema 2: Error de Database

**Causa:** La tabla `users` no tiene los permisos correctos

**Solución:** En Supabase, ve a Authentication > Policies y agrega estas políticas:

```sql
-- Permitir INSERT en users para usuarios autenticados
CREATE POLICY "Users can insert their own profile"
ON users FOR INSERT
TO authenticated
WITH CHECK (auth.uid()::text = email);

-- Permitir SELECT en users para usuarios autenticados
CREATE POLICY "Users can view their own profile"
ON users FOR SELECT
TO authenticated
USING (auth.uid()::text = email);
```

### Problema 3: password_hash no acepta vacío

**Causa:** El campo `password_hash` tiene restricción NOT NULL

**Solución:** Modifica la tabla en Supabase:

```sql
ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL;
```

O cambia el código para usar un valor por defecto:

```dart
'password_hash': 'managed_by_supabase_auth',
```

### Problema 4: Email ya registrado

**Causa:** Ya existe un usuario con ese email en Supabase Auth

**Solución:** 
1. Ve a Supabase > Authentication > Users
2. Elimina el usuario existente
3. Intenta registrarte de nuevo

## 📱 Verificar en Supabase

### 1. Verifica que el usuario se creó en Auth
1. Ve a tu proyecto en Supabase
2. Authentication > Users
3. Deberías ver el usuario con el email que registraste

### 2. Verifica que el perfil se creó en la tabla
1. Ve a Table Editor > users
2. Deberías ver un registro con:
   - nombre: [tu nombre]
   - email: [tu email]
   - role: CLIENTE

## 🎯 Checklist de Verificación

- [ ] Las credenciales en `.env` son correctas
- [ ] La tabla `users` existe en Supabase
- [ ] La tabla `users` tiene las políticas RLS correctas
- [ ] El campo `password_hash` acepta valores vacíos o tiene un default
- [ ] Los logs aparecen en la consola cuando intentas registrarte
- [ ] No hay errores de compilación en Flutter

## 💡 Tip: Ver logs en tiempo real

Si usas VS Code, abre la terminal de Debug Console para ver los logs en tiempo real mientras usas la app.

Tienda de Helados Artesanales 

# 🍦 Heladería NOVA

Bienvenido al repositorio oficial del sistema de gestión para la heladería **NOVA**.  Sis 457
Este proyecto tiene como objetivo digitalizar los procesos internos del negocio, permitiendo un mejor control de productos, ventas, clientes y personal.

# 🧊 Descripción del Negocio
La aplicación de escritorio de una Heladeria Artesanal permitiría organizar y controlar las operaciones de la heladería desde un solo sistema, en lugar de llevar los datos manualmente en cuadernos o Excel.
Todos los datos del negocio se almacenaran de manera ordenada y accesible lo que nos ayudara a brindar un servicio más rápido y eficiente,
tambien nos permite guardar grandes cantidades de información y consultarla rápidamente sin depender de cuadernos o archivos separados un gran beneficio para el dueño etc. El sistema puede impedir que se registren datos incompletos, como un producto sin nombre o un precio vacío.
tambien se podrá implementar usuarios y contraseñas para limitar quién puede acceder al sistema o modificar determinada información.
Tareas que antes se hacían manualmente pueden realizarse con unos cuantos clics un ahorro de tiempo importante para el negocio.

# 💰 Principal Objetivo será:
- Diseñar su base de datos con la cantidad de tablas que se necesite
- CRUD para 2 tablas (al menos 4 campos), eliminación lógica
- Diseño de interfaces del resto de su negocio
- Login
- Compra o Venta

## 🧩🥶 Entidades del Sistema

### 🧁 producto ###
- `id_producto (PK)`
- `nombre`
- `precio`

### ❄️ empleado ###
- `id_empleado (PK)`
- `nombre`
- `apellido`
- `cargo`
- `teléfono`
- `direcciòn`

### 👤 usuario ###
- `id_usuario(PK)`
- `id_empleado(FK)`
- `usuario`
- `clave`

### 🚚 proveedor ###
- `id_proveedor (PK)`
- `nit`
- `teléfono`
- `tipo_producto`

### 🍓 sabor ###
- `id_sabor (PK)`
- `id_producto (FK)`
- `nombre`

### 🍨 tamaños ###
- `id_tamaño (PK)`
- `id_producto (FK)`
- `nombre`

### 🍧 presentaciones ###
- `id_presentación (PK)`
- `id_producto (FK)`
- `nombre`

### 👤 cliente ###
- `id_cliente (PK)`
- `ci`
- `drazon_social`
- `teléfono`

### 💰 venta ###
- `id_venta (PK)`
- `id_usuario (FK)`
- `id_cliente(FK)`
- `fecha`

### 📦 venta_detalle ###
- `id_detalle (PK)`
- `id_venta (FK)`
- `id_producto (FK)`
- `cantidad`
- `precio_unitario`
- `total`

### 🛒 pedido ###
- `id_pedido (PK)`
- `id_cliente (FK)`
- `id_empleado (FK)`
- `fecha_pedido`
- `tipo_pago`
- `estado`

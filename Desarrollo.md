# Notas de desarrollo

## Comandos

```
docker exec -it rolweb-web-1 bash
docker exec -it rolweb-web-1 rails db:migrate
docker exec -it rolweb-web-1 rails console
```

### Restablecer credenciales de rails

```powershell
$env:EDITOR="code --wait"
rails credentials:edit
```

### Borrar caché

```
rails tmp:cache:clear
```

### Gemas

```
bundle add "gema"
bundle remove "gema"
bundle install
bundle outdated
bundle update
```

## Generar cosas y ejemplos

### Scaffold
```
rails generate scaffold
```

LITERALMENTE LO HACE TODO

### Modelo
```
rails generate model <Nombre> [campo:tipo ...]
```

Generar modelo `<Nombre>` (como clase y para luego tabla en DB).

Tipos:

- `:binary`
- `:boolean`
- `:date`
- `:datetime`
- `:decimal`
- `:float`
- `:integer`
- `:primary_key`
- `:string`
- `:text`
- `:time`
- `:timestamp`
- `:references` -> clave foránea

### Controlador

```
rails generate controller <Nombre> [accion ...] [--skip-routes]
```

### Migración

```
rails generate migration <NombreMigracion> [campo:tipo ...]
```

Rails genera el código según el patrón del nombre (la tabla va en plural):

```
rails generate migration Add<Campo>To<Tabla> campo:tipo ...
```
```
rails generate migration Remove<Campo>From<Tabla> campo:tipo ...
```
```
rails generate migration Create<Tabla> [campo:tipo ...]
```
```
rails generate migration CreateJoinTable<Tabla1><Tabla2> tabla1 tabla2
```

Modificadores de campo:

```
campo:tipo:index            # con índice
campo:references            # clave foránea (también campo:belongs_to)
campo:references{polymorphic}
campo:decimal{5,2}          # precisión y escala
campo:string{30}            # longitud
```

También sirve el nombre en snake_case (`add_campo_to_tabla`). Para deshacer:

```
rails destroy migration <NombreMigracion>
rails db:rollback
```


## Importante sobre la versión de ruby

Es deseable que la versión de ruby siempre coincida en:

- archivo .ruby-version
- archivo Gemfile
- archivo Dockerfile
- entorno de desarrollo

## Paletas

### Primera

```css
--c_black: #001219;
--c_white: #F7F7F7;
--c_grey:  #999999;

--c_base: #38002e;
--c_base_alt: #4D003E;
--c_contraste: #98c2ff;
--c_contraste_alt: #b3d1ff;
--c_alternativo: #c375d7;
--c_alternativo_alt: #D797E7;
--c_detalle: #6d5ac6;
--c_detalle_alt: #A095D0;
--c_link: #003d99;
--c_link_alt: #667a99;

--c_danger: #DC143C;
--c_danger_alt: #8B0000;
--c_danger_alternativo: #FF1D8D;
--c_warning: #ffc107;
--c_warning_alt: #e0a800;
```

### Actual

```css
--c_black: #110E08;
--c_white: #F5F0E9;
--c_grey:  #9D8464;

--c_base: #112250;
--c_base_alt: #1D3987;
--c_contraste: #E0C58F;
--c_contraste_alt: #E6CFA3;
--c_alternativo: #D9CBC2;
--c_alternativo_alt: #E4D9D3;
--c_detalle: #3C507D;
--c_detalle_alt: #445A8D;
--c_link: #2D59D2;
--c_link_alt: #5277DA;

--c_danger: #DC143C;
--c_danger_alt: #8B0000;
--c_danger_alternativo: #FF1D8D;
--c_warning: #ffc107;
--c_warning_alt: #e0a800;
```

## HTML reutilizable

```erb
<%= link_to "volver", :back %>
```

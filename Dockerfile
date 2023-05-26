# Utiliza la imagen base de Ruby
FROM ruby:3.1.3

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia el archivo Gemfile y Gemfile.lock al contenedor
COPY Gemfile Gemfile.lock ./

# Instala las gemas de la aplicación
RUN bundle install

# Copia el resto de la aplicación al contenedor
COPY . .

# Expone el puerto 3000 para acceder a la aplicación
EXPOSE 3000

# Define el comando para iniciar el servidor de Rails
# Migrar base de datos e iniciar rails
CMD bin/rails db:migrate RAILS_ENV=development && bin/rails server -b 0.0.0.0

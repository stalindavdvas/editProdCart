# Etapa 1: Construcción de la imagen base
FROM ruby:3.2.2-slim AS builder

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar el Gemfile y Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar las dependencias
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && \
    bundle install && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Etapa 2: Imagen final más ligera
FROM ruby:3.2.2-slim

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar las dependencias instaladas desde la etapa anterior
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Copiar el código fuente de la aplicación
COPY . .

# Exponer el puerto del servidor
EXPOSE 4567

# Comando para iniciar el servidor con Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
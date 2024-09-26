# Usando a imagem oficial do PHP com extensões necessárias
FROM php:8.1-fpm

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip

# Instalar o Composer manualmente para garantir a versão mais recente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Definindo o diretório de trabalho
WORKDIR /var/www

# Copiar todos os arquivos para o diretório de trabalho
COPY . .

# Instalar dependências do Laravel
RUN composer install --ignore-platform-reqs

# Permitir permissões na pasta de armazenamento e cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expor a porta padrão do Laravel
EXPOSE 8000

# Comando que será executado ao iniciar o container
CMD php artisan serve --host=0.0.0.0 --port=8000
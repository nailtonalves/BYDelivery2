#!/bin/bash

# Espera pelo PostgreSQL iniciar completamente
sleep 10

# Executa o script SQL para criar a tabela usuarios
psql -U $POSTGRES_USER -d $POSTGRES_DB -f /docker-entrypoint-initdb.d/inicializar-banco.sql
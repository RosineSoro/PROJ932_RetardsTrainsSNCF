#!/bin/bash

# Nom de ton conteneur
CONTAINER_NAME="sncf_analysis_container"

# Vérifie si le conteneur existe déjà et s'il est en cours d'exécution
docker ps -a | grep $CONTAINER_NAME > /dev/null

# Si le conteneur existe déjà
if [ $? -eq 0 ]; then
    echo "Le conteneur existe déjà. Tentative de démarrage."
    
    # Vérifie si le conteneur est en cours d'exécution
    docker ps | grep $CONTAINER_NAME > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "Le conteneur est déjà en cours d'exécution."
    else
        echo "Le conteneur est arrêté. Relance du conteneur."
        docker restart $CONTAINER_NAME
    fi
else
    # Lance un nouveau conteneur
    echo "Le conteneur n'existe pas. Création et lancement d'un nouveau conteneur."
    docker run -d --name $CONTAINER_NAME my-docker-image
fi

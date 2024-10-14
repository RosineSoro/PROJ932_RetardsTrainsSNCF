# Utilise une image officielle Python comme image de base
FROM python:3.11-slim

# Définit le répertoire de travail dans le conteneur
WORKDIR /app

# Copie le fichier requirements (avec les dépendances Python) dans le conteneur
COPY requirements.txt .

# Installe les dépendances nécessaires
RUN pip install --no-cache-dir -r requirements.txt

# Copie tout le contenu de ton projet dans le conteneur
COPY . .

# Expose le port que Jupyter Notebook va utiliser
EXPOSE 8888

# Définir la commande par défaut qui sera exécutée dans le conteneur
CMD ["python", "main.py"]

# Pour permettre le démarrage de Jupyter Notebook si besoin
ENTRYPOINT ["sh", "-c", "trap 'exit' TERM; while :; do sleep 1; done & jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root & python main.py"]
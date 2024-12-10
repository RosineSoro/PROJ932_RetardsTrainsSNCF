# Utilise une image officielle Python comme image de base
FROM python:3.11-slim

# Installer cron et supervisord
RUN apt-get update && apt-get install -y cron supervisor && rm -rf /var/lib/apt/lists/*

# Définit le répertoire de travail dans le conteneur
WORKDIR /app

# Copie le fichier requirements (avec les dépendances Python) dans le conteneur
COPY requirements.txt .

# Installe les dépendances nécessaires
RUN pip install --no-cache-dir -r requirements.txt

# Copie tout le contenu de ton projet dans le conteneur
COPY . .

# Configuration de cron pour exécuter ton script Python chaque jour à 15h35
RUN echo "35 15 * * * /usr/local/bin/python /app/script.py >> /app/cron.log 2>&1" > /etc/cron.d/my-cron-job

# Donner les permissions au fichier cron
RUN chmod 0644 /etc/cron.d/my-cron-job

# Appliquer le cron job
RUN crontab /etc/cron.d/my-cron-job

# Configuration de supervisord pour gérer cron et Jupyter Notebook
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose le port utilisé par Jupyter Notebook
EXPOSE 8888

# Commande pour démarrer supervisord (qui gère tous les processus)
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

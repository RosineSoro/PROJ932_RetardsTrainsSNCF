import requests
import json
import pandas as pd
from datetime import datetime

# URL de l'API SNCF
api_url = "https://api.sncf.com/v1/coverage/sncf/lines?physical_modes=TGV"

# Clé d'authentification
api_key = "76eef6ab-03ff-4cba-b812-c8b7bee19af4"

# Générer la date d'aujourd'hui au format JJMMYYYY
today_date = datetime.now().strftime('%d%m%Y')

# Effectuer la requête GET avec authentification
try:
    response = requests.get(api_url, auth=(api_key, ""))  # Utiliser la clé comme nom d'utilisateur
    response.raise_for_status()  # Vérifier que la requête a réussi
    data = response.json()

    # Enregistrer les données dans un fichier JSON
    with open(f'data_lines_{today_date}.json', 'w') as json_file:
        json.dump(data, json_file, indent=4)

    # Si les données sont présentes, les convertir en CSV
    if 'lines' in data:
        df = pd.json_normalize(data['lines'])
        csv_filename = f"data_lines_{today_date}.csv"
        df.to_csv(csv_filename, index=False)
        print(f"Les données ont été converties et enregistrées dans '{csv_filename}'.")
    else:
        print("Aucune donnée de ligne trouvée dans la réponse JSON.")

except requests.exceptions.HTTPError as err:
    print(f"Une erreur s'est produite lors de la récupération des données : {err}")
except json.JSONDecodeError:
    print("Erreur de décodage JSON.")
except Exception as e:
    print(f"Une erreur s'est produite : {e}")

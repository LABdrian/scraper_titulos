import os
from dotenv import load_dotenv
import requests
import logging
import smtplib
from email.message import EmailMessage
from bs4 import BeautifulSoup

# Configuración del logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Cargar las variables de entorno
load_dotenv()

EMAIL_ADDRESS = os.getenv('EMAIL_ADDRESS')
EMAIL_PASSWORD = os.getenv('EMAIL_PASSWORD')
URL = os.getenv('SCRAPER_URL')

def check_availability():
    """Verifica la disponibilidad de turnos en la página web."""
    try:
        response = requests.get(URL)
        response.raise_for_status()  # Lanzará un error si la petición no fue exitosa

        soup = BeautifulSoup(response.text, 'html.parser')
        no_turnos_disponibles = soup.find('div', class_='alert alert-danger')

        if no_turnos_disponibles:
            logging.info("No hay turnos disponibles.")
            return False
        else:
            logging.info("Posible disponibilidad de turnos.")
            return True
    except requests.HTTPError as http_err:
        logging.error(f'HTTP error occurred: {http_err}')
    except Exception as err:
        logging.error(f'An unexpected error occurred: {err}')

def send_email():
    """Envía un correo electrónico notificando la disponibilidad de turnos."""
    msg = EmailMessage()
    msg['Subject'] = 'Disponibilidad de Turnos'
    msg['From'] = EMAIL_ADDRESS
    msg['To'] = EMAIL_ADDRESS  # o cualquier destinatario que desees
    msg.set_content('¡Los turnos están disponibles!')

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        smtp.send_message(msg)

def main():
    """Función principal del script."""
    available = check_availability()
    if available:
        send_email()
        logging.info("Email enviado con éxito.")
    else:
        logging.info("No hay turnos disponibles.")

if __name__ == '__main__':
    main()

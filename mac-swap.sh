#!/bin/bash
#toda información es procesable con una buena maquina (santis 16:20)
# Colores ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
LIGHT_BLUE='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # sin color

# Verificar si se ejecuta como root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[ERROR] Este script debe ser ejecutado como root${NC}"
   exit 1
fi

# Ruta genérica según el usuario
MAC_DIR="$HOME/.mac-tool"
MAC_FILE="$MAC_DIR/mac_original.txt"
mkdir -p "$MAC_DIR"

# Detectar interfaz WiFi automáticamente
INTERFAZ=$(ip link | grep -oP '^\d+: \K\w+(?=:)' | grep -E '^wl' | head -n1)

if [[ -z "$INTERFAZ" ]]; then
    echo -e "${RED}[ERROR] No se detectó interfaz WiFi activa (tipo wlan0 o wlo1)${NC}"
    exit 1
fi

while true; do
    clear

    # Obtener MAC actual
    MAC_ACTUAL=$(cat /sys/class/net/$INTERFAZ/address)

    # Leer MAC original si existe
    if [[ -f "$MAC_FILE" ]]; then
        MAC_ORIGINAL=$(cat "$MAC_FILE")
        GUARDADA=true
    else
        MAC_ORIGINAL="No guardada"
        GUARDADA=false
    fi

    # Banner
    echo -e "${RED}"
    cat << "EOF"
 ███▄ ▄███▓ ▄▄▄       ▄████▄       ██████  █     █░ ▄▄▄       ██▓███  
▓██▒▀█▀ ██▒▒████▄    ▒██▀ ▀█     ▒██    ▒ ▓█░ █ ░█░▒████▄    ▓██░  ██▒
▓██    ▓██░▒██  ▀█▄  ▒▓█    ▄    ░ ▓██▄   ▒█░ █ ░█ ▒██  ▀█▄  ▓██░ ██▓▒
▒██    ▒██ ░██▄▄▄▄██ ▒▓▄ ▄██▒     ▒   ██▒░█░ █ ░█ ░██▄▄▄▄██ ▒██▄█▓▒ ▒
▒██▒   ░██▒ ▓█   ▓██▒▒ ▓███▀ ░   ▒██████▒▒░░██▒██▓  ▓█   ▓██▒▒██▒ ░  ░
░ ▒░   ░  ░ ▒▒   ▓▒█░░ ░▒ ▒  ░   ▒ ▒▓▒ ▒ ░░ ▓░▒ ▒   ▒▒   ▓▒█░▒▓▒░ ░  ░
░  ░      ░  ▒   ▒▒ ░  ░  ▒      ░ ░▒  ░ ░  ▒ ░ ░    ▒   ▒▒ ░░▒ ░     
░      ░     ░   ▒   ░           ░  ░  ░    ░   ░    ░   ▒   ░░       
       ░         ░  ░░ ░               ░      ░          ░  ░         
                     ░                                                
EOF
    echo -e "${RED}[github@un-wachin]${NC}"

    echo -e "${LIGHT_BLUE}-DE ${LIGHT_BLUE}A${LIGHT_BLUE}R${LIGHT_BLUE}G${LIGHT_BLUE}E${LIGHT_BLUE}N${WHITE}T${WHITE}I${WHITE}N${YELLOW}A ${WHITE}PAL ${LIGHT_BLUE}MUNDO-${NC}"

    # Info MACs
    echo
    echo -e "[mac original: ${WHITE}$MAC_ORIGINAL${NC}]"
    # echo -n "[mac actual: ${WHITE}$MAC_ACTUAL${NC}] "
    echo -n "[mac actual: $MAC_ACTUAL] "
    if $GUARDADA; then
        echo -e "${GREEN}(guardada)${NC}"
    else
        echo -e "${RED}(no guardada)${NC}"
    fi

    # Menú
    echo
    echo "[1] Guardar MAC original"
    echo "[2] Cambiar MAC por una aleatoria"
    echo "[3] Restaurar MAC original"
    echo "[4] Borrar MAC guardada"
    echo "[5] Salir"
    read -p "#? " OPCION

    # Función para generar una MAC aleatoria válida
    generar_mac_random() {
        hexchars="0123456789ABCDEF"
        echo "02$(for i in {1..5}; do echo -n ":${hexchars:$((RANDOM % 16)):1}${hexchars:$((RANDOM % 16)):1}"; done)"
    }

    case $OPCION in
        1)
            if $GUARDADA; then
                echo -e "${RED}[ERROR] Ya hay una MAC guardada. Si querés guardar otra, borra primero el archivo: $MAC_FILE${NC}"
                continue
            fi
            echo -e "[INFO] Guardando MAC original..."
            echo "$MAC_ACTUAL" > "$MAC_FILE"
            echo -e "${GREEN}[OK] MAC original guardada en $MAC_FILE${NC}"
            ;;
        2)
            if ! $GUARDADA; then
                echo -e "${RED}[ADVERTENCIA] No se encontró MAC original guardada. Se recomienda guardarla antes de continuar.${NC}"
            fi
            NEW_MAC=$(generar_mac_random)
            echo -e "[INFO] Cambiando MAC de $INTERFAZ a $NEW_MAC..."
            ip link set $INTERFAZ down
            ip link set $INTERFAZ address $NEW_MAC
            ip link set $INTERFAZ up
            echo -e "${GREEN}[OK] MAC cambiada a $NEW_MAC${NC}"
            ;;
        3)
            if ! $GUARDADA; then
                echo -e "${RED}[ERROR] No hay MAC original guardada en $MAC_FILE${NC}"
                continue
            fi
            echo -e "[INFO] Restaurando MAC original $MAC_ORIGINAL en $INTERFAZ..."
            ip link set $INTERFAZ down
            ip link set $INTERFAZ address $MAC_ORIGINAL
            ip link set $INTERFAZ up
            echo -e "${GREEN}[OK] MAC restaurada a $MAC_ORIGINAL${NC}"
            ;;
        4)
            if [[ -f "$MAC_FILE" ]]; then
                rm "$MAC_FILE"
                echo -e "${GREEN}[OK] MAC guardada borrada${NC}"
            else
                echo -e "${RED}[INFO] No hay MAC guardada para borrar${NC}"
            fi
            ;;
        5)
            echo -e "${GREEN}Chau perri portate bien ;p${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}[ERROR] Opción inválida${NC}"
            ;;
    esac
done

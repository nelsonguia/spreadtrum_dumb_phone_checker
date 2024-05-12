#!/bin/bash

# Título do programa
# Versão 1.1
# Versão portuguesa
echo ""
echo "#################################"
echo "# Spreadtrum dumb phone checker #"
echo "#################################"
echo ""
echo "O_o Nelson Guia o_O"
echo ""
echo "Nota: script inspirado em código do meu amigo Ricardo S"
echo ""

# Pausa para que o título seja visível
sleep 2

# Função para capturar o sinal SIGINT (Ctrl+c), interromper a monitorização e voltar ao menu principal
func_trap() {
    trap 'echo ""; echo "Monitorização interrompida. Regressando ao menu principal..."; sleep 1; show_menu' INT
}
# Função para verificar se o ID do dispositivo contém "0x4d00" e relatar se é um dispositivo Spreadtrum
check_id() {
    local id="$1"

    func_trap

    if echo "$id" | grep -q "4d00"; then
        echo "USB detectado: Spreadtrum detectado"
        return 0  # Retorna sucesso (código de saída 0)
    fi
    return 1  # Retorna falha (código de saída diferente de 0)
}

# Função para exibir o menu e iniciar a verificação do dispositivo
show_menu() {
    while true; do
        clear
        echo ""
        echo "#################################"
        echo "# Spreadtrum dumb phone checker #"
        echo "#################################"
        echo ""
        echo "Selecione uma opção:"
        echo "1) Verificar se é um dispositivo Spreadtrum e descoberta da tecla mágica para dump"
        echo "2) Sair"

        read -rp "Opção: " choice

        case $choice in
            1)
                echo ""
                echo "Para interromper a pesquisa e regressar ao menu principal, pressione as teclas 'Ctrl+C'"
                echo ""
                echo "==================================================================="
                echo "= Pressione diferentes teclas para identificar a tecla dump,      ="
                echo "= desligue e volte a ligar o equipamento e aguarde confirmação... ="
                echo "==================================================================="
                echo ""

                # Variável para armazenar o número de entradas iguais
                count=0

                # Loop infinito para monitorar a entrada de novos dispositivos USB
                while true; do
                    # Lista todos os dispositivos USB e filtra os dispositivos Spreadtrum
                    device_info=$(lsusb | grep "Spreadtrum Communications Inc.")
                    echo "Device info: $device_info"
                    device_id=$(echo "$device_info" | awk '{print $6}')
                    echo "Device ID: $device_id"
                    
                    # Verifica se o ID do dispositivo contém "0x4d00" e se é um dispositivo Spreadtrum
                    if check_id "$device_id"; then
                        count=$((count + 1))  # Incrementa o contador de entradas iguais
                        echo "Count: $count"
                        if [ "$count" -eq 5 ]; then
                            echo ""
                            echo "****************************************************"
                            echo "Tecla de dump confirmada, esta é a tecla a utilizar."
                            echo "****************************************************"
                            echo ""
                            break  # Sai do loop
                        else
                            echo ""
                            echo "Aguarde mais um pouco para confirmar a tecla de dump..."
                            echo ""
                        fi
                    else
                        echo "Desligue o cabo, pressione outra tecla."
                        echo ""
                        count=0  # Reinicia o contador se o ID não for correto
                    fi
                    sleep 2
                done
                read -rp "Pressione Enter para voltar ao menu..."
                ;;
            2)
                echo ""
                echo "Saindo... Até breve!"
                echo ""
                exit
                ;;
            *)
                echo "Opção inválida. Por favor, escolha uma opção válida."
                read -rp "Pressione Enter para continuar..."
                ;;
        esac
    done
}

# Inicia o menu
show_menu

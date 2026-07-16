import 'package:flutter/material.dart';

// Componente responsável por exibir um horário em um container clicável.
// Recebe uma função de clique, uma cor opcional e o texto do horário.
class ComponentSchedule extends StatelessWidget {
  const ComponentSchedule({
    super.key,
    required this.clickContainer,
    required this.containerColor,
    required this.textoHorario,
  });

  // Função executada quando o usuário toca no container.
  final void Function() clickContainer;

  // Cor de fundo do container. Pode ser nula caso não seja informada.
  final Color? containerColor;

  // Texto que será exibido dentro do container (ex: "08:00", "14:30").
  final String textoHorario;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta o toque do usuário e chama a função recebida pelo componente.
      onTap: clickContainer,

      child: Padding(
        // Adiciona espaçamento vertical entre os componentes de horário.
        padding: const EdgeInsets.symmetric(vertical: 8.0),

        child: Container(
          // Centraliza o texto dentro do container.
          alignment: Alignment.center,

          // Define a aparência do container.
          decoration: BoxDecoration(
            // Adiciona uma borda ao redor do container.
            border: Border.all(),

            // Define a cor de fundo recebida como parâmetro.
            color: containerColor,
          ),

          // Exibe o horário informado.
          child: Text(textoHorario),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/astronomy_event.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';
import 'home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  late Future<List<AstronomyEvent>> events;
  List<AstronomyEvent> filteredEvents = [];
  String? selectedTopic;

  // Lista de tópicos disponíveis
  final List<String> topics = ['Todos', 'Star', 'Galaxy', 'Planet', 'nebula'];

  @override
  void initState() {
    super.initState();

    // Define o intervalo padrão inicial (últimos 7 dias)
    final now = DateTime.now();
    _startDate = now.subtract(Duration(days: 7));
    _endDate = now;

    _loadEvents();
  }

  /// Carrega os eventos com base no intervalo selecionado
  void _loadEvents() {
    final startDateStr = _startDate!.toIso8601String().split('T')[0];
    final endDateStr = _endDate!.toIso8601String().split('T')[0];

    setState(() {
      events = ApiService.fetchAstronomyEvents(
        startDate: startDateStr,
        endDate: endDateStr,
      );
      events.then((allEvents) {
        // Filtra os eventos com base no tópico selecionado
        _filterEvents(allEvents);
      });
    });
  }

  /// Filtra os eventos com base no tópico selecionado
  void _filterEvents(List<AstronomyEvent> allEvents) {
    setState(() {
      if (selectedTopic == null || selectedTopic == 'Todos') {
        // Mostra todos os eventos se o filtro estiver vazio ou for "Todos"
        filteredEvents = allEvents;
      } else {
        // Converte o tópico selecionado para minúsculas para uma comparação flexível
        final topicLower = selectedTopic!.toLowerCase();

        // Filtra os eventos onde o título ou descrição contém o tópico
        filteredEvents = allEvents.where((event) {
          final titleLower = event.title.toLowerCase();
          final descriptionLower = event.description.toLowerCase();

          return titleLower.contains(topicLower) || descriptionLower.contains(topicLower);
        }).toList();
      }
    });
  }

  /// Exibe o seletor de intervalo de datas
  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1995, 6, 16), // Data inicial da NASA APOD
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate!, end: _endDate!),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadEvents(); // Atualiza as notícias com o novo intervalo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos Astronômicos'),
      ),
      body: Column(
        children: [
          // Barra de seleção de intervalo de datas e filtro por tópicos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Intervalo de Datas:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'De: ${_startDate!.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Até: ${_endDate!.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _selectDateRange,
                      child: Text('Alterar Datas'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Dropdown de tópicos
                DropdownButton<String>(
                  value: selectedTopic,
                  hint: Text('Selecione um tópico'),
                  items: topics.map((String topic) {
                    return DropdownMenuItem<String>(
                      value: topic,
                      child: Text(topic),
                    );
                  }).toList(),
                  onChanged: (newTopic) {
                    setState(() {
                      selectedTopic = newTopic;
                      events.then((allEvents) {
                        _filterEvents(allEvents); // Filtra os eventos novamente
                      });
                    });
                  },
                ),
              ],
            ),
          ),

          // Lista de eventos filtrados
          Expanded(
            child: FutureBuilder<List<AstronomyEvent>>(
              future: events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar eventos.'));
                } else if (filteredEvents.isEmpty) {
                  return Center(child: Text('Nenhum evento encontrado para este tópico.'));
                }
                return ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navegar para a tela de detalhes do evento
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(event: filteredEvents[index]),
                          ),
                        );
                      },
                      child: EventCard(event: filteredEvents[index]),
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}

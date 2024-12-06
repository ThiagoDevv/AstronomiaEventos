import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DateSelectorScreen extends StatefulWidget {
  @override
  _DateSelectorScreenState createState() => _DateSelectorScreenState();
}

class _DateSelectorScreenState extends State<DateSelectorScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1995, 6, 16), // Data inicial da NASA APOD
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });

      // Chama a API com as datas selecionadas
      if (_startDate != null && _endDate != null) {
        ApiService.fetchAstronomyEvents(
          startDate: _startDate!.toIso8601String().split('T')[0],
          endDate: _endDate!.toIso8601String().split('T')[0],
        ).then((events) {
          // Exibe os eventos no console (substituir com exibição na tela, se necessário)
          print('Eventos carregados: ${events.length}');
          for (var event in events) {
            print('Evento: ${event.title} - Data: ${event.date}');
          }
        }).catchError((error) {
          print('Erro ao carregar eventos: $error');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Intervalo de Datas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectDateRange,
              child: Text('Selecionar Intervalo de Datas'),
            ),
            if (_startDate != null && _endDate != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'De: ${_startDate!.toLocal()} até ${_endDate!.toLocal()}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

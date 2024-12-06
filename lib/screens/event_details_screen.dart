import 'package:flutter/material.dart';
import '../models/astronomy_event.dart';

class EventDetailsScreen extends StatelessWidget {
  final AstronomyEvent event;

  EventDetailsScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    // Prefixe a URL com o proxy
    final String proxyUrl = 'https://cors-anywhere.herokuapp.com/';
    final String imageUrl = '$proxyUrl${event.imageUrl}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do evento com proxy
            if (event.imageUrl.isNotEmpty)
              Image.network(
                imageUrl, // URL com o proxy
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Erro ao carregar a imagem.',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Data: ${event.date.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    event.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

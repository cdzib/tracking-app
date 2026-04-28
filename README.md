samples, guidance on mobile development, and a full API reference.
# vagonetas_app

Proyecto Flutter para sistema de transporte de vagonetas.

## Estructura recomendada

- lib/
	- features/
		- mapa/
		- reservas/
		- historial/
		- auth/
	- providers/
	- widgets/

## Dependencias instaladas
- google_maps_flutter
- web_socket_channel
- provider

Puedes comenzar a crear tus archivos dentro de cada feature y aprovechar los providers y widgets compartidos.

Recuerda:
- `features/` contiene la lógica y pantallas de cada módulo.
- `providers/` para la gestión de estado global o servicios.
- `widgets/` para componentes reutilizables.

¿Quieres un ejemplo de pantalla de mapa con Google Maps y WebSockets?

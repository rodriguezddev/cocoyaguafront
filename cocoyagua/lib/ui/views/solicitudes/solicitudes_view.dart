import 'package:flutter/material.dart';
import '../../components/buttons/app_button.dart';
import '../../components/tables/app_table.dart';
import '../../components/inputs/app_input.dart';
import '../../components/inputs/app_select.dart';
import '../../components/layout/app_card.dart';
import '../../components/shared/responsive.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/sidebar_menu.dart';
import '../../../models/solicitud_servicio_model.dart';
import '../../../models/solicitud_baja_model.dart';
import '../../../models/solicitud_conexion_model.dart';
// TODO: Importar vistas de registro cuando estén listas
import 'registrar_solicitud_servicio_view.dart'; // Asumiendo que existe o se creará
import 'registrar_solicitud_baja_view.dart'; // Asumiendo que existe o se creará
import 'registrar_solicitud_conexion_view.dart'; // Asumiendo que existe o se creará
import 'package:intl/intl.dart';

class SolicitudRowData {
  final String id;
  final DateTime fechaSolicitud;
  final String tipoSolicitud; // "Servicio", "Baja", "Conexión"
  final String identificadorPrincipal; // Ej: Nombre cliente, Dirección
  final String estado;
  final dynamic solicitudOriginal; // Para acceder al objeto completo

  SolicitudRowData({
    required this.id,
    required this.fechaSolicitud,
    required this.tipoSolicitud,
    required this.identificadorPrincipal,
    required this.estado,
    required this.solicitudOriginal,
  });
}

class SolicitudesView extends StatefulWidget {
  const SolicitudesView({super.key});

  @override
  State<SolicitudesView> createState() => _SolicitudesViewState();
}

class _SolicitudesViewState extends State<SolicitudesView> {
  // Lista unificada para la tabla
  List<SolicitudRowData> _listaSolicitudesConsolidada = [];
  // Listas originales para mantener los datos completos
  List<SolicitudServicio> _solicitudesServicioOriginales = [];
  List<SolicitudBaja> _solicitudesBajaOriginales = [];
  List<SolicitudConexion> _solicitudesConexionOriginales = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatosDeEjemplo();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _cargarDatosDeEjemplo() {
    // Simulación de carga de datos. Reemplazar con lógica real.
    _solicitudesServicioOriginales = List.generate(
        5,
        (i) => SolicitudServicio(
            id: 'serv-$i',
            fechaSolicitud: DateTime.now().subtract(Duration(days: i)),
            tipoPersona: 'Natural',
            tipoDocumento: 'DNI',
            numeroDocumento: '7000000$i',
            nombres: 'Cliente Serv.',
            apellidos: 'Apellido $i',
            telefono: '987654321',
            correo: 'cliente$i@example.com',
            provincia: 'Provincia X',
            ciudad: 'Ciudad Y',
            ubicacion1: 'Calle Falsa 123',
            ubicacion2: 'Frente al parque',
            tomaDomiciliariaId: 'TOMA-SERV-00$i',
            estado: i % 2 == 0 ? 'Completado' : 'En Revisión'));
    // Cargar datos para _solicitudesBaja y _solicitudesConexion de forma similar

    _solicitudesBajaOriginales = List.generate(
        3,
        (i) => SolicitudBaja(
            id: 'baja-$i',
            fechaSolicitud: DateTime.now().subtract(Duration(days: 10 + i)),
            clienteId: 'CLI-BAJA-00$i',
            titularId: 'TIT-BAJA-00$i',
            tomaDomiciliariaId: 'TOMA-BAJA-00$i',
            descripcionMotivo: 'Motivo de baja ${i + 1}',
            estado: i % 2 == 0 ? 'Aprobada' : 'Pendiente'));

    _solicitudesConexionOriginales = List.generate(
        4,
        (i) => SolicitudConexion(
            id: 'conex-$i',
            fechaSolicitud: DateTime.now().subtract(Duration(days: 20 + i)),
            direccion: 'Av. Conexión ${100 + i}',
            descripcionRequerimiento: 'Necesita nueva conexión tipo ${i + 1}',
            estado: i % 2 == 0 ? 'Instalada' : 'Nueva'));

    _consolidarListasParaTabla();
  }

  void _consolidarListasParaTabla() {
    _listaSolicitudesConsolidada.clear();
    for (var s in _solicitudesServicioOriginales) {
      _listaSolicitudesConsolidada.add(SolicitudRowData(
          id: s.id,
          fechaSolicitud: s.fechaSolicitud,
          tipoSolicitud: 'Servicio',
          identificadorPrincipal: '${s.nombres} ${s.apellidos}',
          estado: s.estado,
          solicitudOriginal: s));
    }
    for (var s in _solicitudesBajaOriginales) {
      _listaSolicitudesConsolidada.add(SolicitudRowData(
          id: s.id,
          fechaSolicitud: s.fechaSolicitud,
          tipoSolicitud: 'Baja',
          identificadorPrincipal: 'Cliente ID: ${s.clienteId}',
          estado: s.estado,
          solicitudOriginal: s));
    }
    for (var s in _solicitudesConexionOriginales) {
      _listaSolicitudesConsolidada.add(SolicitudRowData(
          id: s.id,
          fechaSolicitud: s.fechaSolicitud,
          tipoSolicitud: 'Conexión',
          identificadorPrincipal: s.direccion,
          estado: s.estado,
          solicitudOriginal: s));
    }
    // Ordenar por fecha de solicitud descendente (más recientes primero)
    _listaSolicitudesConsolidada
        .sort((a, b) => b.fechaSolicitud.compareTo(a.fechaSolicitud));
    setState(() {});
  }

  Widget _buildHeader() {
    // Similar al de ProductosServiciosView
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Gestión de Solicitudes',
            style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Santiago Meza Alvés',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppTheme.textPrimaryColor)),
                Text('Operador',
                    style: AppTypography.bodySm
                        .copyWith(color: AppTheme.textColor)),
              ],
            ),
            const SizedBox(width: Spacing.md),
            const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, color: Colors.white),
              radius: 20,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const SidebarMenu(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading:
                    false, // Quitar flecha de back si no es necesaria
                title: _buildHeader(),
                toolbarHeight: 80,
                backgroundColor: Colors.transparent,
                elevation: 0,
                // Ya no hay TabBar aquí
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: ListView(
                  // Usamos ListView para permitir scroll si el contenido es largo
                  children: [
                    // Filtros y Botones de Acción
                    if (isMobile)
                      _buildMobileFiltersAndActions()
                    else
                      _buildDesktopFiltersAndActions(),
                    const SizedBox(height: Spacing.lg),
                    // Lista de Solicitudes
                    AppCard(
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildSolicitudesTable(
                            _listaSolicitudesConsolidada.where((s) {
                          // TODO: Implementar lógica de filtrado completa (fecha, estado, búsqueda)
                          final searchLower =
                              _searchController.text.toLowerCase();
                          return searchLower.isEmpty ||
                              s.identificadorPrincipal
                                  .toLowerCase()
                                  .contains(searchLower) ||
                              s.tipoSolicitud
                                  .toLowerCase()
                                  .contains(searchLower) ||
                              s.estado.toLowerCase().contains(searchLower);
                        }).toList()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget genérico para mostrar la lista de solicitudes (a ser detallado)
  Widget _buildMobileFiltersAndActions() {
    return Column(
      children: [
        AppInput(
            hintText: 'Buscar por cliente, documento, estado...',
            controller: _searchController,
            icon: Icons.search,
            label: 'Buscar',
            isLabelVisible: false,
            onChanged: (_) =>
                setState(() {/* TODO: Implementar lógica de filtrado */})),
        const SizedBox(height: Spacing.md),
        // TODO: Añadir AppSelect para filtros de fecha y estado si es necesario
        AppButton(
          text: 'Nueva Solicitud de Servicio',
          icon: Icons.add_circle_outline,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const RegistrarSolicitudServicioView()));
          },
          width: double.infinity, // Para que ocupe todo el ancho en móvil
        ),
        const SizedBox(height: Spacing.sm),
        AppButton(
          text: 'Nueva Solicitud de Baja',
          icon: Icons.remove_circle_outline,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrarSolicitudBajaView()));
          },
          kind: AppButtonKind.secondary, // Diferenciar visualmente
          width: double.infinity,
        ),
        const SizedBox(height: Spacing.sm),
        AppButton(
          text: 'Nueva Solicitud de Conexión',
          icon: Icons.electrical_services_outlined,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const RegistrarSolicitudConexionView()));
          },
          kind: AppButtonKind.secondary,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildDesktopFiltersAndActions() {
    return Row(
      children: [
        Expanded(
          flex: 3, // Más espacio para la búsqueda
          child: AppInput(
              hintText: 'Buscar por cliente, documento, estado...',
              controller: _searchController,
              icon: Icons.search,
              label: 'Buscar',
              onChanged: (_) =>
                  setState(() {/* TODO: Implementar lógica de filtrado */})),
        ),
        // TODO: Añadir AppSelect para filtros de fecha y estado aquí, usando Expanded con flex
        const SizedBox(width: Spacing.md),
        AppButton(
            text: 'Servicio',
            icon: Icons.add,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RegistrarSolicitudServicioView()));
            }),
        const SizedBox(width: Spacing.sm),
        AppButton(
            text: 'Baja',
            icon: Icons.remove,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RegistrarSolicitudBajaView()));
            },
            kind: AppButtonKind.secondary),
        const SizedBox(width: Spacing.sm),
        AppButton(
            text: 'Conexión',
            icon: Icons.electrical_services,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RegistrarSolicitudConexionView()));
            },
            kind: AppButtonKind.secondary),
      ],
    );
  }

  Widget _buildSolicitudesTable(List<SolicitudRowData> items) {
    return AppTable<SolicitudRowData>(
      columns: const [
        'FECHA',
        'TIPO SOLICITUD',
        'CLIENTE/DETALLE',
        'ESTADO',
        'ACCIONES',
      ],
      items: items,
      // TODO: Implementar paginación si es necesario
      buildRow: (item) {
        return DataRow(
          cells: [
            DataCell(Text(DateFormat('dd/MM/yyyy').format(item.fechaSolicitud),
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(item.tipoSolicitud,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(Text(
              item.identificadorPrincipal,
              style: AppTypography.bodySmall
                  .copyWith(color: AppTheme.texttableColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )),
            DataCell(Text(item.estado,
                style: AppTypography.bodySmall
                    .copyWith(color: AppTheme.texttableColor))),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero, // Aplicado
                      constraints: const BoxConstraints(), // Aplicado
                      icon: const Icon(Icons.visibility_outlined,
                          color: AppTheme.primaryColor, size: 18),
                      tooltip: 'Ver',
                      onPressed: () =>
                          _mostrarDialogoDetallesSolicitud(context, item)),
                  IconButton(
                      padding: EdgeInsets.zero, // Aplicado
                      constraints: const BoxConstraints(), // Aplicado
                      icon: const Icon(Icons.edit_outlined,
                          color: AppTheme.primaryColor, size: 18),
                      tooltip: 'Editar',
                      onPressed: () {
                        if (item.solicitudOriginal is SolicitudServicio) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegistrarSolicitudServicioView(
                                          solicitudExistente:
                                              item.solicitudOriginal
                                                  as SolicitudServicio)));
                        } else if (item.solicitudOriginal is SolicitudBaja) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegistrarSolicitudBajaView(
                                          solicitudExistente:
                                              item.solicitudOriginal
                                                  as SolicitudBaja)));
                        } else if (item.solicitudOriginal
                            is SolicitudConexion) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegistrarSolicitudConexionView(
                                          solicitudExistente:
                                              item.solicitudOriginal
                                                  as SolicitudConexion)));
                        }
                      }),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.delete_outline,
                          color: AppTheme.dangerColor, size: 18),
                      tooltip: 'Eliminar',
                      onPressed: () => _eliminarSolicitud(context, item)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: AppTypography.body.copyWith(
              color: AppTheme.textColor), // Ajustar color si es necesario
          children: [
            TextSpan(
                text: '$label ',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoDetallesSolicitud(
      BuildContext context, SolicitudRowData solicitudRow) {
    Widget content;
    String title = 'Detalles de Solicitud';

    if (solicitudRow.solicitudOriginal is SolicitudServicio) {
      final s = solicitudRow.solicitudOriginal as SolicitudServicio;
      title = 'Detalles Solicitud de Servicio';
      content = ListBody(children: <Widget>[
        _buildDetailRow('ID:', s.id),
        _buildDetailRow('Fecha Solicitud:',
            DateFormat('dd/MM/yyyy').format(s.fechaSolicitud)),
        if (s.fechaAprobacion != null)
          _buildDetailRow('Fecha Aprobación:',
              DateFormat('dd/MM/yyyy').format(s.fechaAprobacion!)),
        _buildDetailRow('Tipo Persona:', s.tipoPersona),
        _buildDetailRow(
            'Documento:', '${s.tipoDocumento} ${s.numeroDocumento}'),
        _buildDetailRow('Nombres:', '${s.nombres} ${s.apellidos}'),
        _buildDetailRow('Teléfono:', s.telefono),
        _buildDetailRow('Correo:', s.correo),
        _buildDetailRow(
            'Ubicación:', '${s.ubicacion1}, ${s.ciudad}, ${s.provincia}'),
        _buildDetailRow('Toma ID:', s.tomaDomiciliariaId),
        _buildDetailRow('Estado:', s.estado),
      ]);
    } else if (solicitudRow.solicitudOriginal is SolicitudBaja) {
      final s = solicitudRow.solicitudOriginal as SolicitudBaja;
      title = 'Detalles Solicitud de Baja';
      content = ListBody(children: <Widget>[
        _buildDetailRow('ID:', s.id),
        _buildDetailRow('Fecha Solicitud:',
            DateFormat('dd/MM/yyyy').format(s.fechaSolicitud)),
        _buildDetailRow('Cliente ID:', s.clienteId),
        _buildDetailRow('Titular ID:', s.titularId),
        _buildDetailRow('Toma ID:', s.tomaDomiciliariaId),
        _buildDetailRow('Motivo:', s.descripcionMotivo),
        _buildDetailRow('Estado:', s.estado),
      ]);
    } else if (solicitudRow.solicitudOriginal is SolicitudConexion) {
      final s = solicitudRow.solicitudOriginal as SolicitudConexion;
      title = 'Detalles Solicitud de Conexión';
      content = ListBody(children: <Widget>[
        _buildDetailRow('ID:', s.id),
        _buildDetailRow('Fecha Solicitud:',
            DateFormat('dd/MM/yyyy').format(s.fechaSolicitud)),
        _buildDetailRow('Dirección:', s.direccion),
        _buildDetailRow('Requerimiento:', s.descripcionRequerimiento),
        _buildDetailRow('Estado:', s.estado),
      ]);
    } else {
      content = const Text(
          'No hay detalles disponibles para este tipo de solicitud.');
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                style: AppTypography.h2
                    .copyWith(color: AppTheme.textPrimaryColor)),
            content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: SingleChildScrollView(child: content)),
            actions: <Widget>[
              AppButton(
                  text: 'Cerrar',
                  onPressed: () => Navigator.of(context).pop(),
                  kind: AppButtonKind.ghost)
            ],
          );
        });
  }

  void _eliminarSolicitud(BuildContext context, SolicitudRowData solicitudRow) {
    // TODO: Implementar lógica de eliminación real, actualizando las listas originales y consolidada
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Confirmar Eliminación',
                style: AppTypography.h2
                    .copyWith(color: AppTheme.textPrimaryColor)),
            content: Text(
                '¿Está seguro de que desea eliminar la solicitud de ${solicitudRow.tipoSolicitud} para "${solicitudRow.identificadorPrincipal}"?'),
            actions: <Widget>[
              AppButton(
                  text: 'Cancelar',
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  kind: AppButtonKind.ghost),
              AppButton(
                  text: 'Eliminar',
                  onPressed: () {
                    // Lógica de simulación
                    if (solicitudRow.solicitudOriginal is SolicitudServicio)
                      _solicitudesServicioOriginales
                          .removeWhere((s) => s.id == solicitudRow.id);
                    if (solicitudRow.solicitudOriginal is SolicitudBaja)
                      _solicitudesBajaOriginales
                          .removeWhere((s) => s.id == solicitudRow.id);
                    if (solicitudRow.solicitudOriginal is SolicitudConexion)
                      _solicitudesConexionOriginales
                          .removeWhere((s) => s.id == solicitudRow.id);
                    _consolidarListasParaTabla(); // Actualiza la tabla
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Solicitud eliminada (simulación).')));
                  },
                  kind: AppButtonKind.primary),
            ],
          );
        });
  }
}

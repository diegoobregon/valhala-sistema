package pe.valhala.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "telemetria_iot_particionada")
@Data @NoArgsConstructor @AllArgsConstructor
@IdClass(TelemetriaIotId.class)
public class TelemetriaIot {
    @Id
    @Column(name = "id_telemetria")
    private Long idTelemetria;

    @Id
    @Column(name = "fecha_hora_registro", nullable = false)
    private LocalDateTime fechaHoraRegistro;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_equipo", nullable = false)
    private Equipo equipo;

    @Column(name = "horometro_sensor_iot", precision = 12, scale = 2)
    private BigDecimal horometroSensorIot;

    @Column(name = "voltaje_bateria", precision = 5, scale = 2)
    private BigDecimal voltajeBateria;

    // coordenadas_gps (POINT) se leerá con query nativa para el RF-03
}
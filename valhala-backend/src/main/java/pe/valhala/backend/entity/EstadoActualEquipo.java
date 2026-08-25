package pe.valhala.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "estado_actual_equipos")
@Data @NoArgsConstructor @AllArgsConstructor
public class EstadoActualEquipo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_estado")
    private Integer idEstado;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_equipo", nullable = false, unique = true)
    private Equipo equipo;

    @Column(name = "estatus_operativo", nullable = false, length = 30)
    private String estatusOperativo = "OPERATIVO";

    // ubicacion_geom (POINT) se leerá con query nativa para el RF-03
}
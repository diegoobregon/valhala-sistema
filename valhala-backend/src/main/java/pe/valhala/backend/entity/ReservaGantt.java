package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
@Entity @Table(name = "reservas_gantt") @Data @NoArgsConstructor @AllArgsConstructor
public class ReservaGantt {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_reserva") private Integer idReserva;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_item_contrato", nullable = false) private ItemContrato itemContrato;
    @Column(name = "fecha_inicio_reserva", nullable = false) private LocalDate fechaInicioReserva;
    @Column(name = "fecha_fin_reserva", nullable = false) private LocalDate fechaFinReserva;
    @Column(name = "estado_reserva", nullable = false, length = 20) private String estadoReserva = "PENDIENTE";
}
package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
@Entity @Table(name = "check_out_salidas") @Data @NoArgsConstructor @AllArgsConstructor
public class CheckOutSalida {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_salida") private Integer idSalida;
    @OneToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_reserva", nullable = false, unique = true) private ReservaGantt reserva;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_usuario_mecanico", nullable = false) private Usuario usuarioMecanico;
    @Column(name = "fecha_despacho", nullable = false) private LocalDateTime fechaDespacho;
    @Column(name = "horometro_inicial", nullable = false, precision = 12, scale = 2) private BigDecimal horometroInicial;
}
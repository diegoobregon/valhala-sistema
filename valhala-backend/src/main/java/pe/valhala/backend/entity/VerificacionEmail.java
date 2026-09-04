package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
@Entity @Table(name = "verificaciones_email") @Data @NoArgsConstructor @AllArgsConstructor
public class VerificacionEmail {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_verificacion") private Integer idVerificacion;
    @Column(length = 150) private String email;
    @Column(length = 6) private String codigo;
    @Column(name = "creado_en") private LocalDateTime creadoEn;
    @Column private Boolean usado = false;
}
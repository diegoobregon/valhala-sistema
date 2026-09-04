package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
@Entity @Table(name = "empresas") @Data @NoArgsConstructor @AllArgsConstructor
public class Empresa {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_empresa") private Integer idEmpresa;
    @Column(nullable = false, unique = true, length = 11) private String ruc;
    @Column(name = "razon_social", nullable = false, length = 150) private String razonSocial;
    @Column(name = "email_contacto", nullable = false, unique = true, length = 150) private String emailContacto;
    @Column(nullable = false, length = 20) private String estado = "ACTIVO";
    @Column(name = "fecha_registro") private LocalDateTime fechaRegistro;
}
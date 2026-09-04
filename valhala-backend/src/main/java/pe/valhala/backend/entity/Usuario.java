package pe.valhala.backend.entity;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;
@Entity
@Table(name = "usuarios")
@Data @NoArgsConstructor @AllArgsConstructor
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Usuario {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_usuario") private Integer idUsuario;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_rol", nullable = false) private Rol rol;
    @Column(nullable = false, unique = true, length = 8) private String dni;
    @Column(nullable = false, length = 100) private String nombres;
    @Column(nullable = false, length = 100) private String apellidos;
    @Column(nullable = false, unique = true, length = 120) private String email;
    @JsonIgnore @Column(name = "password_hash", nullable = false) private String passwordHash;
    @Column(name = "estado_activo", nullable = false) private Boolean estadoActivo = true;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_empresa") private Empresa empresa;
}
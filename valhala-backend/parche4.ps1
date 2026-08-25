$base = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-backend\src\main\java\pe\valhala\backend"
$utf8 = New-Object System.Text.UTF8Encoding $false

[System.IO.File]::WriteAllText("$base\controller\LiquidacionController.java", @'
package pe.valhala.backend.controller;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import pe.valhala.backend.repository.LiquidacionFinancieraRepository;
import java.util.List;

@RestController
@RequestMapping("/api/v1/liquidaciones")
public class LiquidacionController {
    private final LiquidacionFinancieraRepository repo;
    public LiquidacionController(LiquidacionFinancieraRepository repo) { this.repo = repo; }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<LiquidacionFinanciera> listar() { return repo.findAll(); }
}
'@, $utf8)

[System.IO.File]::WriteAllText("$base\entity\Usuario.java", @'
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
}
'@, $utf8)
Write-Host "PARCHE4 APLICADO! Reinicia el backend (Ctrl+C, mvn spring-boot:run)"
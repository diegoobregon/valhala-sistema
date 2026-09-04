package pe.valhala.backend.dto;
import lombok.*;
@Data @NoArgsConstructor @AllArgsConstructor
public class RegistroResponse { private String mensaje; private Integer empresaId; private String email; }
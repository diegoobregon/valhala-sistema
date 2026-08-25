package pe.valhala.backend.service;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.valhala.backend.dto.CheckInRequest;
import pe.valhala.backend.entity.CheckInRetorno;
import pe.valhala.backend.entity.CheckOutSalida;
import pe.valhala.backend.entity.EstadoActualEquipo;
import pe.valhala.backend.entity.ItemContrato;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import pe.valhala.backend.entity.Usuario;
import pe.valhala.backend.exception.FraudeHorometroException;
import pe.valhala.backend.repository.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;

@Service
public class CheckInService {
    private final CheckInRetornoRepository retornoRepo;
    private final CheckOutSalidaRepository salidaRepo;
    private final LiquidacionFinancieraRepository liquidacionRepo;
    private final EstadoActualEquipoRepository estadoRepo;
    private final UsuarioRepository usuarioRepo;

    public CheckInService(CheckInRetornoRepository retornoRepo, CheckOutSalidaRepository salidaRepo,
                          LiquidacionFinancieraRepository liquidacionRepo, EstadoActualEquipoRepository estadoRepo, UsuarioRepository usuarioRepo) {
        this.retornoRepo = retornoRepo;
        this.salidaRepo = salidaRepo;
        this.liquidacionRepo = liquidacionRepo;
        this.estadoRepo = estadoRepo;
        this.usuarioRepo = usuarioRepo;
    }

    @Transactional
    public LiquidacionFinanciera retornar(CheckInRequest req, Integer idMecanico) {
        CheckOutSalida salida = salidaRepo.findById(req.getIdSalida()).orElseThrow();
        
        // RF-05: Anti-fraude de horometro
        if (req.getHorometroFinal().compareTo(salida.getHorometroInicial()) < 0) {
            throw new FraudeHorometroException();
        }

        Usuario mecanico = usuarioRepo.findById(idMecanico).orElseThrow();
        
        CheckInRetorno retorno = new CheckInRetorno();
        retorno.setSalida(salida);
        retorno.setUsuarioMecanico(mecanico);
        retorno.setFechaRecepcion(LocalDateTime.now());
        retorno.setHorometroFinal(req.getHorometroFinal());
        retorno.setEstadoDevolucion("CONFORME");
        retornoRepo.save(retorno);

        // RF-05: Liquidacion Matematica
        ItemContrato item = salida.getReserva().getItemContrato();
        BigDecimal horasReales = req.getHorometroFinal().subtract(salida.getHorometroInicial());
        BigDecimal horasBase = horasReales.min(item.getHorasMinimasGarantizadas());
        BigDecimal horasExtra = horasReales.subtract(horasBase).max(BigDecimal.ZERO);
        
        BigDecimal subtotal = (horasBase.multiply(item.getTarifaPorHora())).add(horasExtra.multiply(item.getTarifaPorHora()).multiply(new BigDecimal("1.5")));
        subtotal = subtotal.add(item.getCostoFlete()).setScale(2, RoundingMode.HALF_UP);
        BigDecimal igv = subtotal.multiply(new BigDecimal("0.18")).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(igv);

        LiquidacionFinanciera liq = new LiquidacionFinanciera();
        liq.setRetorno(retorno);
        liq.setHorasBaseConsumidas(horasBase);
        liq.setHorasExtraCalculadas(horasExtra);
        liq.setSubtotal(subtotal);
        liq.setIgv(igv);
        liq.setTotalFacturar(total);
        liq.setEstadoCobro("PENDIENTE");
        liquidacionRepo.save(liq);

        // Regresar estado a OPERATIVO
        EstadoActualEquipo estado = estadoRepo.findByEquipoIdEquipo(salida.getReserva().getItemContrato().getEquipo().getIdEquipo()).orElseThrow();
        estado.setEstatusOperativo("OPERATIVO");
        estadoRepo.save(estado);

        return liq;
    }
}
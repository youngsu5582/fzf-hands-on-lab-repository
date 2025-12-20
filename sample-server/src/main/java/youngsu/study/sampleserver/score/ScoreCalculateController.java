package youngsu.study.sampleserver.score;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/sample")
public class ScoreCalculateController {

    private final ScoreCalculateService scoreCalculateService;

    public ScoreCalculateController(ScoreCalculateService scoreCalculateService) {
        this.scoreCalculateService = scoreCalculateService;
    }

    @GetMapping
    public ResponseEntity<String> some(@RequestParam int value) {
        try {
            log.info("== 요청 시작 ==");
            var result = scoreCalculateService.process(value);
            log.info("== 요청 종료 ==");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}

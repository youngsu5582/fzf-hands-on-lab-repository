package youngsu.study.sampleserver.score;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class ScoreCalculator {

    public int calculate(int value) {
        log.info("계산을 시작합니다. 입력값: {}", value);
        if (value == 5) {
            log.debug("5는 비즈니스 로직상 제곱 연산을 한 후 계산한다.");
            int result = value * value;
            log.info("계산 결과: {}", result);
            return result;
        }
        int result = value + 10;
        log.info("계산 결과: {}", result);
        return result;
    }
}

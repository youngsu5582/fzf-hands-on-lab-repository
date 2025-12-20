package youngsu.study.sampleserver.score;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class ScoreCalculateService {

    private final ScoreCalculator scoreCalculator;

    public String process(int value) {
        var midResult = scoreCalculator.calculate(value);

        var lastResult = doProcess(midResult);
        log.info("최종 연산 결과: {}", lastResult);

        return "당신의 점수는 %d 입니다.".formatted(lastResult);
    }

    private int doProcess(int midResult) {
        if (midResult > 20) {
            log.debug("20을 넘는 숫자는 단위를 변경한다. (* 100)");
            return midResult * 100;
        }
        return midResult;
    }
}

package youngsu.study.sampleserver;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class SampleService {

    public String process(int value) {
        var midResult = calculate(value);
        log.info("중간 연산 결과: {}", midResult);

        var lastResult = doProcess(midResult);
        log.info("최종 연산 결과: {}", lastResult);

        return "당신의 점수는 %d 입니다.".formatted(lastResult);
    }

    private int calculate(int value) {
        if (value == 5) {
            log.debug("5는 비즈니스 로직상 제곱으로 계산한다");
            return value * value;
        }
        return value + 10;
    }

    private int doProcess(int midResult) {
        if (midResult > 20) {
            log.debug("20을 넘는 숫자는 단위를 변경한다. (* 100)");
            return midResult * 100;
        }
        return midResult;
    }
}

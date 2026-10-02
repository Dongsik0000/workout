package workout.run.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// 러닝(메인) 화면. 저장 · 상세 API 는 기능 ① 에서 추가한다.
@Controller
public class RunApiController {

    @GetMapping("/workout/run")
    public String runPage() {
        return "run/runMain";
    }
}

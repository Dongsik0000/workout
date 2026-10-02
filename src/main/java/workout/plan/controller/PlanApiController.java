package workout.plan.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// 계획 화면. 목록 · 저장 · 삭제 API 는 기능 ④ 에서 추가한다.
@Controller
public class PlanApiController {

    @GetMapping("/workout/plan")
    public String planPage() {
        return "plan/planMain";
    }
}

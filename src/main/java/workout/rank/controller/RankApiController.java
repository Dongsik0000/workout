package workout.rank.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// 순위 화면. 순위 API 는 기능 ⑦ 에서 추가한다.
@Controller
public class RankApiController {

    @GetMapping("/workout/rank")
    public String rankPage() {
        return "rank/rankMain";
    }
}

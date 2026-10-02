package workout.record.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// 기록(달력) 화면. 달력 · 하루 목록 API 는 기능 ② 에서 추가한다.
@Controller
public class RecordApiController {

    @GetMapping("/workout/record")
    public String recordPage() {
        return "record/recordMain";
    }
}

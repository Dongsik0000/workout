package workout.friend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// 친구 화면. 검색 · 요청 · 수락 · 삭제 API 는 기능 ⑤ 에서 추가한다.
@Controller
public class FriendApiController {

    @GetMapping("/workout/friend")
    public String friendPage() {
        return "friend/friendMain";
    }
}

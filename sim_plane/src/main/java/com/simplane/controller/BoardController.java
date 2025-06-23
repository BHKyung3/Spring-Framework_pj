package com.simplane.controller;

import com.simplane.domain.BoardVO;
import com.simplane.domain.Criteria;
import com.simplane.domain.PageDTO;
import com.simplane.service.BoardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
@Slf4j
public class BoardController {

    private final BoardService service;

    //목록 읽어오기
    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list================");

        List<BoardVO> list = service.getAll(cri);
        model.addAttribute("list", list);

        int total = service.getTotal(cri);

        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }

    //단 건 읽어오기
    @GetMapping({"/get", "/modify"})
    public void get(@RequestParam Long boardid, Model model) {
        log.info("get......modify..........");

        log.info("boardid:" + boardid);

        model.addAttribute("board", service.get(boardid));
    }

    // 데이터 수정
    @PostMapping("/modify")
    public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
        log.info("modify.....2");

        if(service.modify(board)) {
            rttr.addFlashAttribute("result", "수정 되었습니다.");
        }
        rttr.addAttribute("pageNum", cri.getPageNum());
        rttr.addAttribute("amount", cri.getAmount());
        rttr.addAttribute("type", cri.getType());
        rttr.addAttribute("keyword", cri.getKeyword());

        log.info("modify.....3");

        return "redirect:/board/list";
    }
}

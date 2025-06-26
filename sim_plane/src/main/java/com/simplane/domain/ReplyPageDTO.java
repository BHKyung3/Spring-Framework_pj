package com.simplane.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ReplyPageDTO {

    private Long replyCnt;
    private List<ReplyVO> list;

}

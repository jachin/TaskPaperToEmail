#!/usr/bin/env python

import taskpaper
import mailapp
import wrap

content = taskpaper.get_open_task_paper_doc_as_text()

content = wrap.wrap(content)

mailapp.make_message(
    content,
    subject="snapshot",
    to_addr=["status@clockwork.net", "team_red@mailman.clockwork.net"],
    from_addr="Jachin Rupe <jachin@clockwork.net>",
)

import unittest
import os
import string

from pprint import pprint

from wrap import wrap


class TestWrap(unittest.TestCase):

    def read_file(self, name):

        path = os.path.join(os.path.dirname(os.path.realpath(__file__)), name)
        f = open(path)
        txt = f.readlines()
        f.close()
        return "".join(txt)

    def test_word_wrap(self):
        test_txt = self.read_file('before.txt')
        correct_text = self.read_file('after.txt')
        result_txt = wrap(test_txt)

        self.assertIsNotNone(result_txt)

        result_lines = string.split(result_txt, "\n")
        correct_lines = string.split(correct_text, "\n")

        for i, line in enumerate(correct_lines):

            self.assertEqual(line, result_lines[i])

        for i, line in enumerate(result_lines):

            self.assertEqual(line, correct_lines[i])

        self.assertEqual(correct_text, result_txt)

if __name__ == '__main__':
    unittest.main()

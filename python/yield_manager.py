import sys
# import Timer
import types
import time

class YieldManager(object):
    def __init__(self, tick_delta = 0.01):
        self.generator_dict = {}
        # self._tick_timer = Timer.addRepeatTimer(tick_delta, lambda: self.tick())

    def tick(self):
        cur = time.time()
        for gene, t in self.generator_dict.items():
            if cur >= t:
                self._do_resume_genetator(gene,cur)

    def _do_resume_genetator(self,gene, cur ):
        try:
            self.on_generator_excute(gene, cur)
        except StopIteration,e:
            self.remove_generator(gene)
        except Exception, e:
            print 'unexcepet error', type(e)
            self.remove_generator(gene)

    def add_generator(self, gen, deadline):
        self.generator_dict[gen] = deadline

    def remove_generator(self, gene):
        del self.generator_dict[gene]

    def on_generator_excute(self, gen, cur_time = None):
        t = gen.next()
        cur_time = cur_time or time.time()
        self.add_generator(gen, t + cur_time)

g_yield_mgr = YieldManager()

def yield_dec(func):
    def _inner_func(*args, **kwargs):
        gen = func(*args, **kwargs)
        if type(gen) is types.GeneratorType:
            g_yield_mgr.on_generator_excute(gen)

        return gen
    return _inner_func

@yield_dec
def do(a):
    print 'do', a
    yield 2.5
    print 'post_do', a
    yield 3
    print 'post_do again', a

if __name__ == '__main__':
    do(1)
    for i in range(1, 10):
        print 'simulate a timer, %s seconds passed' % i
        time.sleep(1)
        g_yield_mgr.tick()

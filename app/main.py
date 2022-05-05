from absl import app
from BattleManager import BattleManager
from EnemyAgent import EnemyAgent
from PredictorAgent import PredictorAgent
from pysc2.env import run_loop, sc2_env
from pysc2.lib import actions, features


def main(unused_argv):
    bm = BattleManager()
    agent1 = PredictorAgent(bm)
    agent2 = EnemyAgent(bm)
    try:
        with sc2_env.SC2Env(
                map_name='Flat128',
                players=[sc2_env.Agent(sc2_env.Race.terran),
                         sc2_env.Agent(sc2_env.Race.terran)],
                agent_interface_format=features.AgentInterfaceFormat(
                    action_space=actions.ActionSpace.RAW,
                    use_raw_units=True,
                    raw_resolution=64,
                ),
                step_mul=128,
                disable_fog=True,
        ) as env:
            run_loop.run_loop([agent1, agent2], env, max_episodes=1)
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    app.run(main)

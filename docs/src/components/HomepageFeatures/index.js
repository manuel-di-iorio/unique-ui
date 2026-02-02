import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Composable UI Nodes',
    src: require('@site/static/img/headline_puzzle.png').default,
    description: (
      <>
        Each Node manages layout, style, and interaction, using GameMaker's native flexpanel functions under the hood for automatic positioning and alignment.
        This approach enables dynamic layouts, efficient updates, and easily reusable components.
      </>
    ),
  },
  {
    title: 'Event System',
    src: require('@site/static/img/headline_event.jpeg').default,
    description: (
      <>
        Handle interaction with precision and control.
        It automatically manages mouse events - including hover, click, wheel, and drag-and-drop - through a hierarchical dispatch system.
        Event propagation is optimized using a Dynamic AABB Tree, ensuring accurate hit detection even in complex UIs.
      </>
    ),
  },
  {
    title: 'Optimized for Performance',
    src: require('@site/static/img/headline_fast.jpg').default,
    description: (
      <>
        Designed for scalability and speed.
        It leverages a spatial tree structure to minimize per-frame checks, recalculating only what's necessary.
        Combined with cached surfaces and deferred redraws, this allows large interfaces to remain responsive and lightweight.
      </>
    ),
  },
];

function Feature({ Svg, src, title, description }) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        {src ?
          <img src={src} className={styles.featureSvg} role="img" /> :
          <Svg className={styles.featureSvg} role="img" />}
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}

import React, {useEffect, useRef} from 'react';
import {Animated, TextStyle} from 'react-native';

interface AnimatedCounterProps {
  value: number;
  style?: TextStyle;
  prefix?: string;
  suffix?: string;
  duration?: number;
}

const AnimatedCounter: React.FC<AnimatedCounterProps> = ({
  value,
  style,
  prefix = '',
  suffix = '',
  duration = 1500,
}) => {
  const animatedValue = useRef(new Animated.Value(0)).current;
  const currentValue = useRef(0);

  useEffect(() => {
    const listener = animatedValue.addListener(({value: animValue}) => {
      currentValue.current = animValue;
    });

    Animated.timing(animatedValue, {
      toValue: value,
      duration,
      useNativeDriver: false,
    }).start();

    return () => {
      animatedValue.removeListener(listener);
    };
  }, [value, duration, animatedValue]);

  return (
    <Animated.Text style={style}>
      {animatedValue.interpolate({
        inputRange: [0, value || 1],
        outputRange: [
          `${prefix}0.00${suffix}`,
          `${prefix}${value.toFixed(2)}${suffix}`,
        ],
        extrapolate: 'clamp',
      })}
    </Animated.Text>
  );
};

export default AnimatedCounter;